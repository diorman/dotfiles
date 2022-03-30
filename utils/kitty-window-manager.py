#!/usr/bin/env python

import sys
import os
import json
import re

class Window:
    def __init__(self, dict):
        self.id = dict['id']
        self.title = dict['title']
        self.is_focused = dict['is_focused'] or os.getenv('__KITTY_PREVIOUS_WINDOW_ID') == str(dict['id'])
        self.tab = None
        self.is_active = False

        self.cmd = os.popen('ps -o comm= {}'.format(dict['foreground_processes'][0]['pid'])).read().strip()
        if not self.cmd:
            self.cmd = os.popen('ps -o comm= {}'.format(dict['pid'])).read().strip()

class Tab:
    def __init__(self, dict):
        self.id = dict['id']
        self.title = dict['title']
        self.active_window_history = dict['active_window_history']
        self.session = None
        self.active_window = None
        self.is_focused = False
        self.windows = []

    def append(self, window):
        if self.active_window_history[0] == window.id:
            window.is_active = True
            self.active_window = window

        if window.is_focused:
            self.is_focused = True

        window.tab = self
        self.windows.append(window)

class Session:
    def __init__(self, id):
        self.id = id
        self.tabs = []
        self.is_focused = False
        self.active_tab = None # focused tab; first tab otherwise

    def append(self, tab):
        if tab.is_focused:
            self.is_focused = True
            self.active_tab = tab

        if self.active_tab == None:
            self.active_tab = tab

        tab.session = self
        self.tabs.append(tab)

class KittyTree:
    sessions = []
    windows = {}

    def __init__(self):
        sessions = []
        named_sessions = {}
        os_windows = json.loads(os.popen('kitty @ ls').read())

        for os_window in os_windows:
            for tab_dict in os_window['tabs']:
                if tab_dict['windows'][0]['env'].get('__KITTY_HELPER_TAB', '0') == '1':
                    continue

                session_id = tab_dict['windows'][0]['env'].get('__KITTY_SESSION_ID', '')

                tab = Tab(tab_dict)

                for window_dict in tab_dict['windows']:
                    window = Window(window_dict)
                    self.windows[window.id] = window
                    tab.append(window)

                if session_id:
                    if session_id not in named_sessions:
                        named_sessions[session_id] = Session('@{}'.format(session_id))
                    named_sessions[session_id].append(tab)
                else:
                    session = Session(tab.title)
                    session.append(tab)
                    sessions.append(session)

        self.sessions = sorted(sessions + list(named_sessions.values()), key=lambda s: s.id)

    def format(self):
        formated_sessions = []
        for index, session in enumerate(self.sessions):
            formated_sessions.append(self.__format_session(session, len(self.sessions) - 1 == index))

        return '\n'.join(self.__flatten(formated_sessions))

    def __flatten(self, t):
        return [item for sublist in t for item in sublist]

    def __format_id(self, id):
        return '[{}]'.format(id)

    def __tree_decoration_current_item(self, is_last):
        return '└─' if is_last else  '├─'

    def __tree_decoration_nested_item(self, is_last):
        return '  ' if is_last else '│ '

    def __format_window(self, window, index, is_last, tree_decoration_base):
        active_label = '*' if window.is_active else ''
        tree_decoration = '{} {}'.format(tree_decoration_base, self.__tree_decoration_current_item(is_last))

        return ' '.join([
            tree_decoration,
            '{}:'.format(index + 1),
            # '{}{}:'.format(window.cmd, active_label),
            '{}{}'.format(active_label, window.title),
            self.__format_id(window.id)
        ])

    def __format_tab(self, tab, index, is_last, tree_decoration_base):
        tree_decoration = '{} {}'.format(tree_decoration_base, self.__tree_decoration_current_item(is_last))
        active_window = tab.active_window

        formated_tab = ' '.join([
            tree_decoration,
            '{}:'.format(index + 1),
            '<tab>',
            # '{}*'.format(active_window['cmd']),
            format_id(active_window.id)
        ])

        if len(tab.windows) == 1:
            window = tab.windows[0]
            return [self.__format_window(window, 0, is_last, tree_decoration_base)]

        formated_windows = []
        for index, window in enumerate(tab.windows):
            formated_windows.append(self.__format_window(window, index, len(tab.windows) - 1 == index, '{} {}'.format(tree_decoration_base, self.__tree_decoration_nested_item(is_last))))

        return [formated_tab] + formated_windows

    def __format_session(self, session, is_last):
        focused_label = '(current)' if session.is_focused else ''
        tree_decoration = self.__tree_decoration_current_item(is_last)

        formatted_session = ' '.join(list(filter(None, [
            tree_decoration,
            '{}'.format(session.id),
            focused_label,
            self.__format_id(session.active_tab.active_window.id)
        ])))

        if len(session.tabs) == 1:
            formated_windows = []
            windows = session.tabs[0].windows
            for index, window in enumerate(windows):
                formated_windows.append(self.__format_window(window, index, len(windows) - 1 == index, self.__tree_decoration_nested_item(is_last)))
            return [formatted_session] + formated_windows

        formatted_tabs = []

        for index, tab in enumerate(session.tabs):
            formatted_tabs.append(self.__format_tab(tab, index, len(session.tabs) - 1 == index, self.__tree_decoration_nested_item(is_last)))

        return [formatted_session] + flatten(formatted_tabs)

FZF = 'fzf --no-bold --color bg+:green,fg+:black,hl+:bold:black,hl:magenta,gutter:black,pointer:black,disabled:black --no-info --pointer "=>"'

def fatal(msg):
    print(f'Fatal: {msg}')
    sys.exit(1)


def open_project():
    result = os.popen(f'find "$CODEPATH/" -mindepth 3 -maxdepth 3 -type d | sed "s|$CODEPATH/||" | {FZF} --print-query').read().split('\n')[:-1]

    if not result:
        os.system('[ -n "$__KITTY_PREVIOUS_WINDOW_ID" ] && kitty @ focus-window --match id:$__KITTY_PREVIOUS_WINDOW_ID 2>/dev/null')
        return

    if len(result) == 2:
        dir = '{}/{}'.format(os.getenv('CODEPATH'), result[-1])
    else:
        print(f"Cloning '{result[0]}'...")
        dir = os.popen(f'''git-get '{result[0]}' 2>&1 | head -n 1 | sed -r "s/Cloning into '(.*)'.../\\1/"''').read().strip()

    session_id = re.compile('^.+/(.+/.+)$').match(dir).group(1)
    os.system(f'kitty @ focus-tab --match env:__KITTY_SESSION_ID={session_id} 2>/dev/null || kitty @ launch --type tab --cwd "{dir}" --env __KITTY_SESSION_ID={session_id} --no-response')

def switch():
    window_id = os.getenv('__KITTY_PREVIOUS_WINDOW_ID')
    tree = KittyTree()
    result_parser = "sed -r 's/^.*\[(.*)\]$/\\1/'"
    fzf = f'''echo '{tree.format()}' | {FZF} --preview "kitty @ get-text --ansi --match id:(echo {{-1}} | {result_parser})" --layout=reverse-list --disabled --no-info --prompt ""'''
    window_id = os.popen('''{} | {}'''.format(fzf, result_parser)).read().strip()

    if window_id:
        os.system(f'kitty @ focus-window --match id:{window_id}')

def cli_arg(index, default = None):
    return sys.argv[index] if len(sys.argv) > index else default

def main():
    command = cli_arg(1)

    if command == "switch":
        switch()
    elif command == "open-project":
        open_project()
    else:
        fatal("expected commands: open-project | switch")

main()
