from kitty.fast_data_types import Screen
from kitty.tab_bar import DrawData, ExtraData, TabBarData

def draw_tab(
    draw_data: DrawData, screen: Screen, tab_bar_data: TabBarData,
    before: int, max_title_length: int, index: int, is_last: bool,
    extra_data: ExtraData
) -> int:
    caption = []
    # get command without args. The title always contains the location whether there's an active command or not
    maybe_command = tab_bar_data.title.split(' ')[0]
    if maybe_command not in ['exit', 'kitty', 'fish', '~'] and '/' not in maybe_command:
        caption.append(maybe_command)

    num_windows = tab_bar_data.num_windows

    if maybe_command == 'kitty':
        num_windows -= 1

    if num_windows > 1:
        caption.append(f'[{num_windows}w]')

    title = f'{index}:{" ".join(caption)}' if caption else str(index)
    screen.draw(' ' + title + ' ')
    screen.cursor.x += 1

    return screen.cursor.x
