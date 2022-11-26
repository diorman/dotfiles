import os
import sys
from typing import Any, Dict
from kitty.boss import Boss
from kitty.window import Window

sys.path.append(f'{os.getenv("HOME")}/.config/kitty')

from window_manager.windows import is_kitten_with_ui_window

def on_focus_change(boss: Boss, window: Window, data: Dict[str, Any])-> None:
    if not data['focused'] and is_kitten_with_ui_window(window):
        boss.call_remote_control(window, ('close-window', '--self', '--no-response', '--ignore-no-match'))
