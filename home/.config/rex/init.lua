-- Nawigacja między panelami jak w Herdr: Ctrl+A, potem h/j/k/l.
rex.bind("ctrl+a>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+a>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+a>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+a>l", "pane.focus", { direction = "right" })

-- Nawigacja między kartami: Ctrl+A, potem p/n.
rex.bind("ctrl+a>p", "client.tab.previous")
rex.bind("ctrl+a>n", "client.tab.next")

-- Dwukrotne Ctrl+A przekazuje zwykłe Ctrl+A do terminala.
rex.bind("ctrl+a>ctrl+a", "pane.send_key", { key = "ctrl+a" })
