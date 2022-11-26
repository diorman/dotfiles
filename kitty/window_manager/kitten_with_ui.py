import os
import re
from typing import List
from kitty.boss import Boss
from kitty.window import Window
from kittens.tui.handler import result_handler

from windows import get_tab_groups, get_tab_group_key
from system import which, CODEPATH

FZF_DEFAULT_OPTIONS =  '--no-bold --color bg+:green,fg+:black,hl+:bold:black,hl:magenta,gutter:black,pointer:black,disabled:black --no-sort --no-multi --no-info --layout default --pointer "=>"'

def main(args: List[str]) -> str:
    action = args[1]

    if action == 'select_tab_group':
        return select_tab_group_prompt(args[2:])
    elif action == 'select_tab_in_tab_group':
        return select_tab_in_tab_group_prompt(args[2:])
    elif action == 'select_code_project':
        return select_code_project_prompt()

def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    if not answer:
        return

    target_window = boss.window_id_map.get(target_window_id)

    if not target_window:
        return

    action = args[1]

    if action == 'select_tab_group':
        select_tab_group_handler(boss, target_window, answer)
    if action == 'select_tab_in_tab_group':
        select_tab_in_tab_group_handler(boss, target_window, answer)
    elif action == 'select_code_project':
        select_code_project_handler(boss, target_window, answer)

def select_tab_group_prompt(choices: List[str]):
    return fzf(choices, '-n 2')

def select_tab_group_handler(boss: Boss, target_window: Window, answer: str):
    tab_group_key = answer.split()[1]
    tab_group = get_tab_groups(boss, target_window.os_window_id).get(tab_group_key)
    if tab_group:
        boss.set_active_window(tab_group.active_window)

def select_tab_in_tab_group_prompt(choices: List[str]):
    return fzf(choices, '-n 2')

def select_tab_in_tab_group_handler(boss: Boss, target_window: Window, answer: str):
    index = int(re.sub('[\[\]]', '', answer.split()[0])) - 1
    tab_group_key = get_tab_group_key(target_window)
    tab_group = get_tab_groups(boss, target_window.os_window_id).get(tab_group_key)

    if tab_group and index < len(tab_group.tabs):
        _, active_window = tab_group.tabs[index]
        boss.set_active_window(active_window)

def select_code_project_prompt():
    find = which('find')
    sed = which('sed')
    sort = which('sort')
    output = os.popen(f'''find '{CODEPATH}' -mindepth 3 -maxdepth 3 -type d | {sed} 's|{CODEPATH}/||' | {sort} --ignore-case''')
    choices = output.read().split('\n')
    output.close()
    return fzf(choices)

def select_code_project_handler(boss: Boss, target_window: Window, answer):
    tab_group = get_tab_groups(boss, target_window.os_window_id).get(f'@code/{answer}')
    if not tab_group:
        boss.call_remote_control(target_window, ('launch', '--type=tab', f'--cwd={CODEPATH}/{answer}', '--no-response'))
    else:
        boss.set_active_window(tab_group.active_window)

def fzf(choices: List[str], fzf_options = '', delimiter = '\n'):
    fzf = which('fzf')
    echo = which('echo')
    choices_str = delimiter.join(map(str, choices))
    output = os.popen(f'''{echo} '{choices_str}' | {fzf} {FZF_DEFAULT_OPTIONS} {fzf_options}''')
    selection = output.read().strip()
    output.close()
    return selection

