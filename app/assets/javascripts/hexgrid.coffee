jQuery ($) ->
  createHex = (grid, styleClass) ->
    $("<div class='hex'/>").css({
      "width": grid.tileWidth + "px",
      "height": grid.tileHeight + "px",
      "line-height": grid.tileHeight + "px",
    }).addClass(styleClass)

  placeHex =(elem,x,y) ->
    inv = grid.screenpos(x, y)
    elem.css("left", inv.x + "px")
    elem.css("top", inv.y + "px")

  gridElement = $('#hexagonal-grid')[0]

  # Creating a grid
  grid = hex.grid(gridElement, {})
  root = $(grid.root)

  # Element to show the currently hovered tile
  hoveredElement = createHex(grid, 'current')
  root.append(hoveredElement)

  # Setting mouse movement related tile events
  grid.addEvent("tileover", (e, x, y) ->
    placeHex(hoveredElement,x,y)
  )
