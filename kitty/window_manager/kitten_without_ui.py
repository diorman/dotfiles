from typing import List
from kitty.boss import Boss
from kitty.window import Window
from kittens.tui.handler import result_handler

from windows import get_tab_groups

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

def select_tab_group_handler(boss: Boss, target_window: Window):
    n = 1
    choices = []
    tab_groups = get_tab_groups(boss, target_window.os_window_id)

    for tab_group_key in tab_groups.keys():
        # the home tab group has its own key binding so it is excluded here
        if tab_group_key != '@home':
            choices.append(f'[{n if n < 10 else "_"}] {tab_group_key}')
            n += 1

    if choices:
        boss.call_remote_control(target_window, ('kitten', './window_manager/kitten_with_ui.py', 'select_tab_group', *choices))
