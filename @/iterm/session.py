#!/usr/bin/env python3.10

# To be put in
# `~/Library/Application Support/iTerm2/Scripts/*.py`

import iterm2


async def set_tab(tab, title, cwd):
    await tab.async_set_title(title)
    session = tab.current_session
    if session is None:
        return
    await session.async_send_text(f"cd {cwd}\nclear\nls\n")


async def main(connection):
    app = await iterm2.async_get_app(connection)
    window = app.current_terminal_window
    if window is None:
        # You can view this message in the script console.
        return print("No current window")
    tabs = [
        ("editor", "~/repos/math"),
        ("compiler", "~/repos/math"),
        ("mathlib", "~/repos/math/.lake/packages/mathlib/Mathlib"),
        ("lean.nvim", "~/.local/share/nvim/lazy/lean.nvim"),
        ("ℓ·server", "~/repos/tex"),
        ("ℓ·editor", "~/repos/tex"),
    ]

    # if len(window.tabs) > 1:
    #     for i in range(len(window.tabs) - 1):
    #         await window.tabs[i].async_close()

    if window.current_tab is not None:
        await set_tab(window.current_tab, tabs[0][0], tabs[0][1])
        tabs = tabs[1:]

    for title, cwd in tabs:
        tab = await window.async_create_tab()
        await set_tab(tab, title, cwd)


iterm2.run_until_complete(main)
