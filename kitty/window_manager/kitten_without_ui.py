from typing import List
from kitty.boss import Boss
from kitty.window import Window
from kittens.tui.handler import result_handler
from kitty.fast_data_types import focus_os_window, get_os_window_title

from windows import list_tabs, set_active_tab, list_os_windows, is_kitten_with_ui_window, get_active_window_in_tab
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

    if action == 'new_tab':
        new_tab_handler(boss, target_window)
    elif action == 'select_tab':
        select_tab_handler(boss, target_window)
    elif action == 'new_window':
        new_window_handler(boss, target_window, args[2])
    elif action == 'select_os_window':
        select_os_window_handler(boss, target_window)
    elif action == 'goto_os_window':
        goto_os_window_handler(boss, target_window, int(args[2]))
    elif action == 'close_other_os_windows':
        close_other_os_windows_handler(boss, target_window)

def new_tab_handler(boss: Boss, target_window: Window):
    title = target_window.user_vars.get('title') or ''
    boss.call_remote_control(target_window, ('launch', '--type=tab', f'--cwd=current', f'--var=title={title}', '--no-response'))

def new_window_handler(boss: Boss, target_window: Window, location: str):
    title = target_window.user_vars.get('title') or ''
    boss.call_remote_control(target_window, ('launch', f'--location={location}', f'--cwd=current', f'--var=title={title}', '--no-response'))

def select_os_window_handler(boss: Boss, target_window: Window):
    choices = []

    for index, os_window in enumerate(list_os_windows(boss)):
        choices.append(f'[{index + 1}] {os_window.title} {" " if os_window.is_focused else ""}')

    if choices:
        boss.call_remote_control(target_window, ('kitten', './window_manager/kitten_with_ui.py', 'select_os_window', *choices))

def goto_os_window_handler(boss: Boss, target_window: Window, index: int):
    if index == -1:
        goto_default_os_window(boss, target_window)
    elif index == 0:
        goto_last_os_window(boss, target_window)
    else:
        goto_index_os_window(boss, target_window, index - 1)


def goto_default_os_window(boss: Boss, target_window: Window):
    os_windows = [os_window for os_window in list_os_windows(boss) if not os_window.is_code_project]

    if not os_windows:
        boss.call_remote_control(target_window, ('launch', '--type=os-window', '--no-response'))
    else:
        focus_os_window(os_windows[0].id)

def goto_last_os_window(boss: Boss, target_window: Window):
    last_window = None

    for window in boss.all_windows:
        if window.os_window_id != target_window.os_window_id and (not last_window or last_window.last_focused_at < window.last_focused_at):
            last_window = window

    if last_window:
        focus_os_window(last_window.os_window_id)

def goto_index_os_window(boss: Boss, target_window: Window, index: int):
    os_windows = list_os_windows(boss)
    if index < len(os_windows):
        focus_os_window(os_windows[index].id)

def select_tab_handler(boss: Boss, target_window: Window):
    tabs = list_tabs(boss, target_window.os_window_id)

    if not tabs:
        return

    choices = []

    for index, tab in enumerate(tabs):
        title = tab.title
        is_active = tab.is_active
        number_of_windows = tab.number_of_windows
        choices.append(f'[{index + 1}] {title} [{number_of_windows}w] {" " if is_active else ""}')

    boss.call_remote_control(target_window, ('kitten', './window_manager/kitten_with_ui.py', 'select_tab', *choices))

def close_other_os_windows_handler(boss, target_window):
    os_window_ids = set()

    for os_window in list_os_windows(boss):
        if os_window.id != target_window.os_window_id:
            os_window_ids.add(os_window.id)

    for os_window_id in os_window_ids:
        boss.confirm_os_window_close(os_window_id)

