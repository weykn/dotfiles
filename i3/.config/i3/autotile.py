#!/usr/bin/env python3
import i3ipc

i3 = i3ipc.Connection()

def autotile(i3, e):
    tree = i3.get_tree()
    focused = tree.find_focused()
    if not focused:
        return

    workspace = focused.workspace()
    windows = [w for w in workspace.leaves() if w.window]

    count = len(windows)

    if count == 1:
        i3.command('split h')
    elif count == 2:
        i3.command('split v')
    elif count >= 3:
        last = windows[-2]
        layout = last.parent.layout
        if layout == 'splitv':
            i3.command('split h')
        else:
            i3.command('split v')

i3.on('window::new', autotile)
i3.main()
