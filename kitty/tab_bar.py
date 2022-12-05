import sys
import os
from kitty.fast_data_types import Screen
from kitty.tab_bar import DrawData, ExtraData, TabBarData, draw_title
from kitty.fast_data_types import get_boss

window_manager_path = f'{os.getenv("HOME")}/.config/kitty/window_manager'

if window_manager_path not in sys.path:
    sys.path.append(window_manager_path)

from windows import get_tab_groups, get_tab_group_key, is_kitten_with_ui_window, get_active_window_in_tab

def draw_tab(
    draw_data: DrawData, screen: Screen, tab_bar_data: TabBarData,
    before: int, max_title_length: int, index: int, is_last: bool,
    extra_data: ExtraData
) -> int:
    tab_info = get_tab_info(tab_bar_data.tab_id)

    if tab_info:
        screen.draw(' ' + str(tab_info[2] + 1) + ' ')
        # screen.cursor.x = screen.cursor.x + 1

    return screen.cursor.x

def get_tab_info(tab_id):
    boss = get_boss()
    active_tab = boss.active_tab

    if not boss or not active_tab or is_kitten_with_ui_window(active_tab.active_window):
        return None

    active_window = get_active_window_in_tab(active_tab)

    if not active_window:
        return None

    tab_group_key = get_tab_group_key(active_window)
    tab_group = get_tab_groups(boss, active_tab.os_window_id).get(tab_group_key)

    if not tab_group:
        return None

    for index, (tab, tab_active_window) in enumerate(tab_group.tabs):
        if tab.id == tab_id:
            return (tab, tab_active_window, index)

    return None
