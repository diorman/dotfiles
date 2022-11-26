from typing import List
from kitty.boss import Boss
from kitty.window import Window
from kittens.tui.handler import result_handler

from windows import get_tab_groups
from system import HOMEPATH

def main(args: List[str]) -> str:
    pass

@result_handler(no_ui = True)
def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    action = args[1]
    target_window = boss.window_id_map.get(target_window_id)

    if not target_window:
        return

    if action == 'select_tab_group':
        select_tab_group_handler(boss, target_window)
    elif action == 'select_tab_group_by_index':
        select_tab_group_by_index_handler(boss, target_window, int(args[2]))

def select_tab_group_handler(boss: Boss, target_window: Window):
    n = 1
    choices = []
    tab_groups_keys = get_tab_groups(boss, target_window.os_window_id).keys()

    for tab_group_key in tab_groups_keys:
        # the home tab group has its own key binding so it is excluded here
        if tab_group_key != '@home':
            choices.append(f'[{n if n < 10 else "_"}] {tab_group_key}')
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
        tab_groups_keys = list(filter(lambda key: key != '@home', tab_groups.keys()))

        if index <= len(tab_groups_keys):
            tab_group = tab_groups.get(tab_groups_keys[index - 1])

    if tab_group and tab_group.active_window.id != target_window.id:
        boss.set_active_window(tab_group.active_window)
