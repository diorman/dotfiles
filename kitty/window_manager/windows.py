import re
from typing import List, Dict, Optional
from kitty.boss import Boss, OSWindowDict
from kitty.window import Window, WindowDict
from kitty.tabs import Tab, TabDict
from kitty.fast_data_types import get_os_window_title

from system import HOMEPATH, CODEPATH

class OSWindow:
    def __init__(self, os_window_dict: OSWindowDict):
        self.id = os_window_dict['id']
        self.title = get_os_window_title(os_window_dict)
        self.is_code_project = self.title.startswith('@code/')
        self.is_focused = os_window_dict['is_focused']

class TabGroup:
    def __init__(self):
        self.active_window = None
        self.tabs = []

    def add_tab(self, tab: Tab, tab_active_window: Window):
        self.tabs.append((tab, tab_active_window))
        if not self.active_window or self.active_window.last_focused_at < tab_active_window.last_focused_at:
            self.active_window = tab_active_window

def list_os_windows(boss: Boss) -> list[OSWindow]:
    os_windows = []

    for os_window_dict in boss.list_os_windows():
        os_windows.append(OSWindow(os_window_dict))

    return os_windows

def get_os_window_title(os_window_dict: OSWindowDict):
    user_vars_title = os_window_dict['tabs'][0]['windows'][0]['user_vars'].get('title')
    if user_vars_title:
        return user_vars_title

    for tab_dict in os_window_dict['tabs']:
        if tab_dict['is_active']:
            return tab_dict['title']

    return ''

def find_os_window_by_title(boss: Boss, title: str):
    for os_window in list_os_windows(boss):
        if os_window.title == title:
            return os_window
    return None

class TabX:
    def __init__(self, tab_dict: TabDict):
        self.id = tab_dict['id']
        self.title = tab_dict['title']
        self.is_active = tab_dict['is_active']
        self.number_of_windows = len(tab_dict['windows'])

def list_tabs(boss: Boss, os_window_id: int) -> list[TabX]:
    tm = boss.os_window_map.get(os_window_id)

    if not tm:
        return []

    tabs = []
    for tab_dict in tm.list_tabs():
        tabs.append(TabX(tab_dict))

    return tabs

def set_active_tab(boss: Boss, os_window_id: int, tab_id: int):
    tm = boss.os_window_map.get(os_window_id)

    if not tm:
        return

    for tab in tm:
        if tab.id == tab_id:
            tm.set_active_tab(tab)
            return

def get_active_window_in_tab(tab: Tab) -> Optional[Window]:
    active_window = tab.active_window

    if not is_kitten_with_ui_window(active_window):
        return active_window

    active_window = None

    for window in get_windows_in_tab(tab):
        if not active_window or window.last_focused_at > active_window.last_focused_at:
            active_window = window

    return active_window

def is_kitten_with_ui_window(window: Window) -> bool:
    return (len(window.child.cmdline) >= 5
            and window.child.cmdline[0].endswith('kitty')
            and window.child.cmdline[1] == '+runpy'
            and window.child.cmdline[4].endswith('window_manager/kitten_with_ui.py'))

def get_windows_in_tab(tab: Tab):
    windows = []
    for window in tab.windows.all_windows:
        if not window.destroyed and not is_kitten_with_ui_window(window):
            windows.append(window)
    return windows
