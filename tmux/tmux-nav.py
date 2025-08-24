#!/usr/bin/env python3
import urwid
import subprocess

def get_sessions():
    result = subprocess.run(['tmux', 'list-sessions', '-F', '#S'], capture_output=True, text=True)
    return result.stdout.strip().splitlines()

def get_windows(session):
    result = subprocess.run(
        ['tmux', 'list-windows', '-t', session, '-F', '#I:#W:#F'],
        capture_output=True, text=True
    )
    windows = []
    for line in result.stdout.strip().splitlines():
        idx, name, flags = line.split(':')
        windows.append((idx, name, flags))
    return windows

def create_session(name):
    subprocess.run(['tmux', 'new-session', '-d', '-s', name])

def create_window(session, name):
    subprocess.run(['tmux', 'new-window', '-t', session, '-n', name])

def rename_session(old, new):
    subprocess.run(['tmux', 'rename-session', '-t', old, new])

def rename_window(session, old_idx, new_name):
    subprocess.run(['tmux', 'rename-window', '-t', f'{session}:{old_idx}', new_name])

def switch_window(session, win_idx):
    subprocess.run(['tmux', 'switch-client', '-t', f'{session}:{win_idx}'])


class TmuxNav:
    def __init__(self):
        self.mode = "session"  # session or window
        self.current_session = None
        self.menu_stack = []
        self.show_sessions()

    def show_sessions(self):
        self.mode = "session"
        self.session_list = get_sessions()
        self.edit = urwid.Edit("New session: ")
        body = [self.edit, urwid.Divider()]
        for idx, sess in enumerate(self.session_list):
            button = urwid.Button(f"{idx}: {sess}")
            urwid.connect_signal(button, 'click', self.enter_session, sess)
            body.append(urwid.AttrMap(button, None, focus_map='reversed'))
        self.listbox = urwid.ListBox(urwid.SimpleFocusListWalker(body))
        self.loop = urwid.MainLoop(
            self.listbox,
            unhandled_input=self.unhandled_input
        )
        self.loop.run()

    def enter_session(self, button, session):
        self.mode = "window"
        self.current_session = session
        self.window_list = get_windows(session)
        self.edit = urwid.Edit("New window: ")
        body = [self.edit, urwid.Text(f"Session: {session}"), urwid.Divider()]
        for idx, name, flags in self.window_list:
            display = f"{name} {'(*)' if '*' in flags else ''}"
            btn = urwid.Button(display)
            urwid.connect_signal(btn, 'click', lambda b, info=(session, idx): self.goto_window(info))
            body.append(urwid.AttrMap(btn, None, focus_map='reversed'))
        self.menu_stack.append(self.listbox)
        self.listbox = urwid.ListBox(urwid.SimpleFocusListWalker(body))
        self.loop.widget = self.listbox

    def goto_window(self, info):
        session, win_idx = info
        switch_window(session, win_idx)
        raise urwid.ExitMainLoop()

    def unhandled_input(self, key):
        if key in ('esc', 'q'):
            if self.menu_stack:
                self.listbox = self.menu_stack.pop()
                self.loop.widget = self.listbox
            else:
                raise urwid.ExitMainLoop()
        elif key in ('j', 'down'):
            self.move_focus(1)
        elif key in ('k', 'up'):
            self.move_focus(-1)
        elif key == 'enter':
            text = self.edit.edit_text.strip()
            if not text:
                return
            if self.mode == "session":
                if text in self.session_list:
                    self.enter_session(None, text)
                else:
                    create_session(text)
                    self.enter_session(None, text)
            elif self.mode == "window":
                names = [name for idx, name, flags in self.window_list]
                if text in names:
                    idx = [i for i, (i_, n, f) in enumerate(self.window_list) if n == text][0]
                    win_idx = self.window_list[idx][0]
                    self.goto_window((self.current_session, win_idx))
                else:
                    create_window(self.current_session, text)
                    self.enter_session(None, self.current_session)
        elif key == 'ctrl r':
            focus_widget, idx = self.listbox.get_focus()
            if isinstance(focus_widget.base_widget, urwid.Button):
                if self.mode == "session":
                    old_name = focus_widget.base_widget.get_label().split(": ",1)[1]
                    new_name = input(f"Rename session '{old_name}' to: ")
                    if new_name.strip():
                        rename_session(old_name, new_name.strip())
                        self.show_sessions()
                elif self.mode == "window":
                    parts = focus_widget.base_widget.get_label().split(" ")
                    old_name = parts[0]
                    win_idx = [i for i, (i_, n, f) in enumerate(self.window_list) if n == old_name][0]
                    new_name = input(f"Rename window '{old_name}' to: ")
                    if new_name.strip():
                        rename_window(self.current_session, self.window_list[win_idx][0], new_name.strip())
                        self.enter_session(None, self.current_session)

    def move_focus(self, step):
        focus_widget, idx = self.listbox.get_focus()
        walker = self.listbox.body
        new_idx = max(1, min(len(walker) - 1, idx + step))  # skip edit
        self.listbox.set_focus(new_idx)


def main():
    TmuxNav()


if __name__ == "__main__":
    main()

