import re
from typing import List, Dict, Optional
from kitty.boss import Boss
from kitty.window import Window
from kitty.tabs import Tab

from system import HOMEPATH, CODEPATH

class TabGroup:
    def __init__(self, active_window):
        self.active_window = active_window
        self.windows = [active_window]

def get_tab_groups(boss: Boss, os_window_id: int) -> Dict[str, Window]:
    tab_groups = {}

    for tab in boss.all_tabs:
        if tab.os_window_id != os_window_id:
            continue

        active_window = get_active_window_in_tab(tab)

        if not active_window:
            continue

        tab_group_key = get_tab_group_key(active_window)
        tab_group = tab_groups.get(tab_group_key)

        if not tab_group:
            tab_group = TabGroup(active_window)
            tab_groups[tab_group_key] = tab_group
            continue

        tab_group.windows.append(active_window)

        if active_window.last_focused_at > tab_group.active_window.last_focused_at:
            tab_group.active_window = active_window

    return tab_groups

def get_active_window_in_tab(tab: Tab) -> Optional[Window]:
    active_window = tab.active_window

    if not is_kitten_with_ui_window(active_window):
        return active_window

    active_window = None

    for window in tab.windows.all_windows:
        if is_kitten_with_ui_window(window):
            continue

        if not active_window or window.last_focused_at > active_window.last_focused_at:
            active_window = window

    return active_window

def get_tab_group_key(window: Window) -> str:
    tab_group_key = window.child.current_cwd or window.child.cwd
    tab_group_key = re.sub(f'^{CODEPATH}', '@code', tab_group_key)
    tab_group_key = re.sub(f'^{HOMEPATH}', '@home', tab_group_key)
    return tab_group_key

def is_kitten_with_ui_window(window: Window) -> bool:
    return (len(window.child.cmdline) >= 5
            and window.child.cmdline[0].endswith('kitty')
            and window.child.cmdline[1] == '+runpy'
            and window.child.cmdline[4].endswith('window_manager/kitten_with_ui.py'))
