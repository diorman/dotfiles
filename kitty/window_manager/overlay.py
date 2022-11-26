import os
from typing import List
from kitty.boss import Boss
from kitty.window import Window
from kittens.tui.handler import result_handler

from utils import get_tab_groups

FZF_DEFAULT_OPTIONS =  '--no-bold --color bg+:green,fg+:black,hl+:bold:black,hl:magenta,gutter:black,pointer:black,disabled:black --no-info --layout default --pointer "=>" +m'

def main(args: List[str]) -> str:
    action = args[1]

    if action == 'select_tab_group':
        return select_tab_group_prompt(args[2:])

def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    if not answer:
        return

    target_window = boss.window_id_map.get(target_window_id)

    if not target_window:
        return

    action = args[1]

    if action == 'select_tab_group':
        select_tab_group_handler(boss, target_window, answer)

def select_tab_group_prompt(choices: List[str]):
    return fzf(choices, '-n 2')

def select_tab_group_handler(boss: Boss, target_window: Window, answer: str):
    tab_group_id = answer.split()[1]
    tab_group = get_tab_groups(boss, target_window.os_window_id).get(tab_group_id)
    if tab_group and tab_group.active_window.id != target_window.id:
        boss.set_active_window(tab_group.active_window)

def fzf(choices: List[str], fzf_options = '', delimiter = '\n'):
    fzf = f'{os.getenv("HOME")}/.nix-profile/bin/fzf'
    choices_str = delimiter.join(map(str, choices))
    output = os.popen(f'''echo '{choices_str}' | {fzf} {FZF_DEFAULT_OPTIONS} {fzf_options}''')
    selection = output.read().strip()
    output.close()

    return selection

