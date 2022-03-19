#!/usr/bin/env python

import os
import json

def flatten(t):
    return [item for sublist in t for item in sublist]

def format_id(id):
    return "[{}]".format(id)

def tree_decoration_current_item(is_last):
    return "└─" if is_last else  "├─"

def tree_decoration_nested_item(is_last):
    return "  " if is_last else "│ "

def format_window(window, index, is_last, tree_decoration_base):
    active_label = "*" if window["active"] else ""
    tree_decoration = "{} {}".format(tree_decoration_base, tree_decoration_current_item(is_last))

    return " ".join([
        tree_decoration,
        "{}:".format(index + 1),
        "{}{}:".format(window["cmd"], active_label),
        window["title"],
        format_id(window["id"])
    ])

def format_tab(tab, index, is_last, tree_decoration_base):
    tree_decoration = "{} {}".format(tree_decoration_base, tree_decoration_current_item(is_last))
    active_window = tab["active_window"]

    formated_tab = " ".join([
        tree_decoration,
        "{}:".format(index + 1),
        "<tab>",
        # "{}*".format(active_window["cmd"]),
        format_id(active_window["id"])
    ])

    if len(tab["windows"]) == 1:
        window = tab["windows"][0]
        return [format_window(window, 0, is_last, tree_decoration_base)]

    formated_windows = []
    for index, window in enumerate(tab["windows"]):
        formated_windows.append(format_window(window, index, len(tab["windows"]) - 1 == index, "{} {}".format(tree_decoration_base, tree_decoration_nested_item(is_last))))

    return [formated_tab] + formated_windows

def format_session(session, is_last):
    focused_label = "(active)" if session["is_focused"] else ""
    tree_decoration = tree_decoration_current_item(is_last)

    formatted_session = " ".join(list(filter(None, [
        tree_decoration,
        "{}".format(session["id"]),
        focused_label,
        format_id(session["active_tab"]["active_window"]["id"])
    ])))

    if len(session["tabs"]) == 1:
        formated_windows = []
        windows = session["tabs"][0]["windows"]
        for index, window in enumerate(windows):
            formated_windows.append(format_window(window, index, len(windows) - 1 == index, tree_decoration_nested_item(is_last)))
            # window = session["tabs"][0]["windows"][0]
        return [formatted_session] + formated_windows

    formatted_tabs = []

    for index, tab in enumerate(session["tabs"]):
        formatted_tabs.append(format_tab(tab, index, len(session["tabs"]) - 1 == index, tree_decoration_nested_item(is_last)))

    return [formatted_session] + flatten(formatted_tabs)


def tab_mapper(tab):
    windows = []
    active_window = None
    is_focused = False

    for window in tab["windows"]:
        cmd = os.popen("ps -o comm= {}".format(window["foreground_processes"][0]["pid"])).read().strip() # `ps -o comm= #{window["foreground_processes"][0]["pid"]}`.strip
        if not cmd: cmd = os.popen("ps -o comm= {}".format(window["pid"])).read().strip()

        w = {
            "id": window["id"],
            "title": window["title"],
            "cmd": cmd,
            "is_focused": window["is_focused"] or os.getenv("__PREVIOUS_KITTY_WINDOW_ID") == str(window["id"]),
            "active": tab["active_window_history"][0] == window["id"]
        }

        windows.append(w)

        if w["active"]: active_window = w
        if w["is_focused"]: is_focused = True

    return {
        "id": tab["id"],
        "title": tab["title"],
        "is_focused": is_focused,
        "active_window": active_window,
        "windows": windows
    }

def parse_kitty_windows():
    named_sessions = {}
    sessions = []
    os_windows = json.loads(os.popen("kitty @ ls").read())

    for os_window in os_windows:
        for tab in os_window["tabs"]:
            session_id = tab["windows"][0]["env"].get("__SESSION_ID", "")

            if session_id == "__hidden":
                continue

            t = tab_mapper(tab)

            if session_id:
                if session_id not in named_sessions:
                    named_sessions[session_id] = {
                        "tabs":  [],
                        "active_tab": t,
                        "is_focused": False,
                        "id": "@{}".format(session_id)
                    }

                if t["is_focused"]:
                    named_sessions[session_id]["active_tab"] = t
                    named_sessions[session_id]["is_focused"] = True

                named_sessions[session_id]["tabs"].append(t)
            else:
                sessions.append({
                    "tabs": [t],
                    "active_tab": t,
                    "is_focused": t["is_focused"],
                    "id": t["title"]
                })

    return sorted(sessions + list(named_sessions.values()), key=lambda s: s["id"])

def main():
    sessions = parse_kitty_windows()

    formated_sessions = []
    for index, session in enumerate(sessions):
        formated_sessions.append(format_session(session, len(sessions) -1 == index))

    print("\n".join(flatten(formated_sessions)))

main()
