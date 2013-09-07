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
    # Highlight the currently hovered cell
    placeHex(hoveredElement,x,y)
  )

  # Tiletap is only fired when not dragging the grid
  grid.addEvent("tiletap", (e, x, y) ->
    # Create new placeholder element to give a visual indication where we will be creating our new element
    newElement = createHex(grid, 'new')

    # Place the element on the grid
    placeHex(newElement,x,y)

    # Show the new element on the grid
    root.append(newElement)

    # Get pixel position based on grid coordinates
    inv = grid.screenpos(x, y)

    # Show content search
    $("#content-search").css({
      "left": (inv.x + grid.origin.x) + "px",
      "top": (inv.y + grid.origin.y) + "px"
    }).find("input").focus()
  )