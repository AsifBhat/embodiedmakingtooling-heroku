jQuery ($) ->
  createHex = (grid, img) ->
    $("<div/>").css({
      "display": "none",
      "position": "absolute",
      "text-align": "center",
      "width": grid.tileWidth + "px",
      "height": grid.tileHeight + "px",
      "line-height": grid.tileHeight + "px",
      "background": "url('/assets/images/hex-" + img + "-trans.png') no-repeat",
    })

  placeHex =(x,y,hexcell) ->
    hex.log([x, y])
    inv = grid.screenpos(x, y)
    hexcell.css("left", inv.x + "px")
    hexcell.css("top", inv.y + "px")
    

  elem = $('#hexagonal-grid')[0]

  # Creating a grid
  grid = hex.grid(elem, {})
  root = $(grid.root)

  # Element to show the currently hovered tile
  curr = createHex(grid,'curr')
  root.append(curr)

  adj1 = createHex(grid,'adj')
  adj2 = createHex(grid,'adj')
  adj3 = createHex(grid,'adj')
  adj4 = createHex(grid,'adj')
  adj5 = createHex(grid,'adj')
  adj6 = createHex(grid,'adj')

  root.append(adj1)
  root.append(adj2)
  root.append(adj3)
  root.append(adj4)
  root.append(adj5)
  root.append(adj6)

  # Setting mouse movement related tile events
  grid.addEvent("tileover", (e, x, y) ->
    placeHex(x,y,curr)
    placeHex(x+1,y,adj1)
    placeHex(x-1,y,adj2)
    placeHex(x,y+1,adj3)
    placeHex(x,y-1,adj4)
    placeHex(x+1,y-1,adj5)
    placeHex(x-1,y+1,adj6)
  )

  # Setting mouse movement related grid events
  grid.addEvent("gridover", (e, x, y) ->
    hex.log([x, y], e.type)
    curr.css("display", "")
    adj1.css("display", "")
    adj2.css("display", "")
    adj3.css("display", "")
    adj4.css("display", "")
    adj5.css("display", "")
    adj6.css("display", "")
  )

  grid.addEvent("gridout", (e, x, y) ->
    hex.log([x, y], e.type)
    curr.css("display", "none")
    adj1.css("display", "none")
    adj2.css("display", "none")
    adj3.css("display", "none")
    adj4.css("display", "none")
    adj5.css("display", "none")
    adj6.css("display", "none")
  )
