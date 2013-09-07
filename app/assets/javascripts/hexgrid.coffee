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
    $("#content-search").css("position","absolute")
    $("#content-search").css("left", inv.x + "px")
    $("#content-search").css("top", inv.y + "px")

  elem = $('#hexagonal-grid')[0]

  # Creating a grid
  grid = hex.grid(elem, {})
  root = $(grid.root)

  # Element to show the currently hovered tile
  curr = createHex(grid,'curr')
  root.append(curr)

  # Setting mouse movement related tile events
  grid.addEvent("tileclick", (e, x, y) ->
    placeHex(x,y,curr)
    $("#content-search").css("display","")
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

  $(document).keyup((e) =>
    if e.keyCode == 27
        $("#pannel").slideToggle()
        $("#content-search").css("display","none")
  )
