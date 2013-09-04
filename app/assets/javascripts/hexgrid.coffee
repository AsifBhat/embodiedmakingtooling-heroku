jQuery ($) ->
  createHex = (grid, img = 'curr') ->
    $("<div/>").css({
      "display": "none",
      "position": "absolute",
      "text-align": "center",
      "width": grid.tileWidth + "px",
      "height": grid.tileHeight + "px",
      "line-height": grid.tileHeight + "px",
      "background": "url('/assets/images/hex-" + img + "-trans.png') no-repeat",
    })

  elem = $('#hexagonal-grid')[0]

  # Creating a grid
  grid = hex.grid(elem, {})
  root = $(grid.root)

  # Element to show the currently hovered tile
  curr = createHex(grid)
  root.append(curr)

  # Setting mouse movement related tile events
  grid.addEvent("tileover", (e, x, y) ->
    hex.log([x, y], e.type)
    inv = grid.screenpos(x, y)
    curr.css("left", inv.x + "px")
    curr.css("top", inv.y + "px")
    curr.html([x, y] + '')
  )

  # Setting mouse movement related grid events
  grid.addEvent("gridover", (e, x, y) ->
    hex.log([x, y], e.type)
    curr.css("display", "")
  )

  grid.addEvent("gridout", (e, x, y) ->
    hex.log([x, y], e.type)
    curr.css("display", "none")
  )
