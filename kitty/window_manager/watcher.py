from typing import Any, Dict
from kitty.boss import Boss
from kitty.window import Window

def on_focus_change(boss: Boss, window: Window, data: Dict[str, Any])-> None:
    if not data['focused'] and is_kitten_with_ui_window(window):
        boss.call_remote_control(window, ('close-window', '--self', '--no-response', '--ignore-no-match'))

def is_kitten_with_ui_window(window: Window) -> bool:
    return (len(window.child.cmdline) >= 5
            and window.child.cmdline[0].endswith('kitty')
            and window.child.cmdline[1] == '+runpy'
            and window.child.cmdline[4].endswith('window_manager/kitten_with_ui.py'))

