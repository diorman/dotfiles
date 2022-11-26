from typing import List
from kitty.boss import Boss
from kitty.window import Window
from kittens.tui.handler import result_handler

from windows import get_tab_groups, get_tab_group_key, is_kitten_with_ui_window, get_active_window_in_tab, get_windows_in_tab
from system import HOMEPATH

def main(args: List[str]) -> str:
    pass

@result_handler(no_ui = True)
def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    action = args[1]
    target_window = boss.window_id_map.get(target_window_id)

    if target_window and is_kitten_with_ui_window(target_window):
        tab = target_window.tabref()
        if not tab:
            return
        target_window = get_active_window_in_tab(tab)

    if not target_window:
        return

    if action == 'select_tab_group':
        select_tab_group_handler(boss, target_window)
    elif action == 'select_tab_group_by_index':
        select_tab_group_by_index_handler(boss, target_window, int(args[2]))
    elif action == 'select_tab_in_tab_group':
        select_tab_in_tab_group_handler(boss, target_window)
    elif action == 'select_tab_in_tab_group_by_index':
        select_tab_in_tab_group_by_index_handler(boss, target_window, int(args[2]))
    elif action == 'return_tab_group':
        return_tab_group_handler(boss, target_window)
    elif action == 'return_tab_in_tab_group':
        return_tab_in_tab_group_handler(boss, target_window)

def select_tab_group_handler(boss: Boss, target_window: Window):
    n = 1
    choices = []
    tab_groups_keys = get_tab_groups(boss, target_window.os_window_id).keys()
    target_tab_group_key = get_tab_group_key(target_window)

    for tab_group_key in tab_groups_keys:
        # the home tab group has its own key binding so it is excluded here
        if tab_group_key != '@home':
            choices.append(f'[{n}] {tab_group_key} {" " if tab_group_key == target_tab_group_key else ""}')
            n += 1

    if choices:
        boss.call_remote_control(target_window, ('kitten', './window_manager/kitten_with_ui.py', 'select_tab_group', *choices))

def select_tab_group_by_index_handler(boss: Boss, target_window: Window, index: int):
    tab_groups = get_tab_groups(boss, target_window.os_window_id)
    tab_group = None

    if index == 0:
        tab_group = tab_groups.get('@home')
        if not tab_group:
            boss.call_remote_control(target_window, ('launch', '--type=tab', f'--cwd={HOMEPATH}', '--no-response'))
    else:
        index -= 1
        tab_groups_keys = list(filter(lambda key: key != '@home', tab_groups.keys()))

        if index < len(tab_groups_keys):
            tab_group = tab_groups.get(tab_groups_keys[index])

    if tab_group:
        boss.set_active_window(tab_group.active_window)

def select_tab_in_tab_group_handler(boss: Boss, target_window: Window):
    tab_group_key = get_tab_group_key(target_window)
    tab_group = get_tab_groups(boss, target_window.os_window_id).get(tab_group_key)

    if not tab_group:
        return

    choices = []

    for index, (tab, active_window) in enumerate(tab_group.tabs):
        len_windows = len(get_windows_in_tab(tab))
        choices.append(f'[{index + 1}] {active_window.title} [{len_windows}w] {" " if active_window.tab_id == target_window.tab_id else ""}')

    boss.call_remote_control(target_window, ('kitten', './window_manager/kitten_with_ui.py', 'select_tab_in_tab_group', *choices))

def select_tab_in_tab_group_by_index_handler(boss: Boss, target_window: Window, index: int):
    tab_group_key = get_tab_group_key(target_window)
    tab_group = get_tab_groups(boss, target_window.os_window_id).get(tab_group_key)
    index -= 1

    if tab_group and index < len(tab_group.tabs):
        _, active_window = tab_group.tabs[index]
        boss.set_active_window(active_window)


def return_tab_group_handler(boss: Boss, target_window: Window):
    current_tab_group_key = get_tab_group_key(target_window)
    tab_groups = get_tab_groups(boss, target_window.os_window_id)
    tab_groups.pop(current_tab_group_key)

    active_window = None

    for tab_group_key, tab_group in tab_groups.items():
        if not active_window or active_window.last_focused_at < tab_group.active_window.last_focused_at:
            active_window = tab_group.active_window

    if active_window:
        boss.set_active_window(active_window)

def return_tab_in_tab_group_handler(boss: Boss, target_window: Window):
    tab_group_key = get_tab_group_key(target_window)
    tab_group = get_tab_groups(boss, target_window.os_window_id).get(tab_group_key)

    if not tab_group:
        return

    active_window = None

    for _, tab_active_window in tab_group.tabs:
        if tab_group.active_window.id == tab_active_window.id:
            continue

        if not active_window or active_window.last_focused_at < tab_active_window.last_focused_at:
            active_window = tab_active_window

    if active_window:
        boss.set_active_window(active_window)
