import os

import re
from typing import List
from kitty.boss import Boss
from kitty.window import Window
from kittens.tui.handler import result_handler
from kitty.fast_data_types import focus_os_window

from windows import list_tabs, set_active_tab, list_os_windows, is_kitten_with_ui_window, get_active_window_in_tab
from system import which, CODEPATH

FZF_DEFAULT_OPTIONS =  '--no-bold --color bg+:green,fg+:black,hl+:bold:black,hl:magenta,gutter:black,pointer:black,disabled:black --no-sort --no-multi --no-info --layout default --cycle --pointer " " --prompt " ❯ " '

def main(args: List[str]) -> str:
    action = args[1]

    if action == 'select_os_window':
        return select_os_window_prompt(args[2:])
    elif action == 'select_tab':
        return select_tab_prompt(args[2:])
    elif action == 'select_code_project':
        return select_code_project_prompt()

def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    if not answer:
        return

    target_window = boss.window_id_map.get(target_window_id)

    if target_window and is_kitten_with_ui_window(target_window):
        tab = target_window.tabref()
        if not tab:
            return
        target_window = get_active_window_in_tab(tab)

    if not target_window:
        return

    action = args[1]

    if action == 'select_os_window':
        select_os_window_handler(boss, target_window, answer)
    if action == 'select_tab':
        select_tab_handler(boss, target_window, answer)
    elif action == 'select_code_project':
        select_code_project_handler(boss, target_window, answer)

def select_os_window_prompt(choices: List[str]):
    return fzf(choices, '-n 2')

def select_os_window_handler(boss: Boss, target_window: Window, answer: str):
    index = int(re.sub('[\\[\\]]', '', answer.split()[0])) - 1
    os_windows = list_os_windows(boss)
    if os_windows and index < len(os_windows):
        focus_os_window(os_windows[index].id)

def select_tab_prompt(choices: List[str]):
    return fzf(choices, '-n 2')

def select_tab_handler(boss: Boss, target_window: Window, answer: str):
    index = int(re.sub('[\\[\\]]', '', answer.split()[0])) - 1
    tabs = list_tabs(boss, target_window.os_window_id)

    if tabs and index < len(tabs):
        set_active_tab(boss, target_window.os_window_id, tabs[index].id)

def select_code_project_prompt():
    find = which('find')
    sed = which('sed')
    sort = which('sort')
    output = os.popen(f'''find '{CODEPATH}' -mindepth 3 -maxdepth 3 -type d | {sed} 's|{CODEPATH}/||' | {sort} --ignore-case''')
    choices = output.read().split('\n')
    output.close()
    return fzf(choices)

def select_code_project_handler(boss: Boss, target_window: Window, answer):
    os_window_title = f'@code/{answer}'
    existing_os_window = None

    for os_window in list_os_windows(boss):
        if os_window.title == os_window_title:
            existing_os_window = os_window
            break

    if not existing_os_window:
        boss.call_remote_control(target_window, ('launch', '--type=os-window', f'--cwd={CODEPATH}/{answer}', f'--os-window-title={os_window_title}', f'--var=title={os_window_title}', '--no-response'))
    else:
        focus_os_window(existing_os_window.id)

def fzf(choices: List[str], fzf_options = '', delimiter = '\n'):
    fzf = which('fzf')
    echo = which('echo')
    choices_str = delimiter.join(map(str, choices))
    output = os.popen(f'''{echo} '{choices_str}' | {fzf} {FZF_DEFAULT_OPTIONS} {fzf_options}''')
    selection = output.read().strip()
    output.close()
    return selection

