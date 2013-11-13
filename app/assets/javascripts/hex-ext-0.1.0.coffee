jQuery ($) ->

  # Creating a grid
  gridElement = $('#hexagonal-grid')[0]
  appContext.grid = hex.grid(gridElement, {})
  size = hex.size(appContext.grid.elem)
  appContext.grid.reorient(size.x * 0.5, size.y * 0.5)
  root = $(appContext.grid.root)


  appContext.grid.createHex = (styleClass, text = "") ->
    $("<div class='hex' >"+text+"</div>").css({
      "width": appContext.grid.tileWidth + "px",
      "height": appContext.grid.tileHeight + "px",
      "line-height": appContext.grid.tileHeight + "px",
    }).addClass(styleClass)

    # Element to show the currently hovered tile
  hoveredElement = appContext.grid.createHex('current')
  root.append(hoveredElement)
  idwithtooltip =  $('#desctooltip')
  idwithtooltip.css("width", size + "px")
  idwithtooltip.css("height", size + "px") 

   # Create new placeholder element to give a visual indication where we will be creating our new element
  newElement = appContext.grid.createHex('new') 

  appContext.grid.placeHex =(elem,x,y) ->
    inv = appContext.grid.screenpos(x, y)
    elem.css("left", inv.x + "px")
    elem.css("top", inv.y + "px")

  appContext.grid.showHoveredElement = (xc, yc) ->
    this.placeHex(hoveredElement,xc,yc)  

  appContext.grid.placeNewElement = (xc, yc) ->
    this.placeHex(newElement,xc,yc)
    # Show the new element on the grid
    root.append(newElement)
    newElement

  # Placing tooltip if not an empty cell
  # elementid should be replaced with the content to be displayed in the tooltip.
  appContext.grid.showTooltip = (x,y,tooltipInfo) ->
    inv = appContext.grid.screenpos(x, y)
    idwithtooltip.attr("data-original-title",tooltipInfo+"<br/><button id='deleteButton' class='btn-mini'><span class='icon-remove remove_btn'></span></button>")
    idwithtooltip.css({
      "display": "",
      "left": (inv.x + appContext.grid.origin.x) + "px",
      "top": (inv.y + appContext.grid.origin.y) + "px"
    })
    $("#desctooltip").tooltip('show')
    $("#deleteButton").click((e) -> 
      appContext.grid.deletePosition(parseInt(x,10),parseInt(y,10))
    )

  appContext.grid.hideTooltip = () ->  
    $("#desctooltip").tooltip('hide')

  appContext.grid.placeOnGrid = (elemwithpos) ->
    elemid = elemwithpos.elementId
    
    etype = elemid.substr(0,1)
    switch etype
      when 'S' then cls = "stories"
      when 'F' then cls = "forces"
      when 'C' then cls = "solutionComponents"
    
    cellToPlace = appContext.grid.createHex(cls, elemid)
    $(cellToPlace).attr("id",elemwithpos.posId)
    root.append(cellToPlace)
    this.placeHex(cellToPlace,elemwithpos.x,elemwithpos.y)
    

  appContext.grid.displayAllPositions = (positions) ->
    $('.forces, .solutionComponents, .stories').remove()
    $("#desctooltip").tooltip('hide')
    Util.log.console("Displaying all clusters")
    Util.log.console(positions)
    $.each(positions, (i, value) ->
      appContext.grid.placeOnGrid (value)
    )

  appContext.grid.getAllNeighbourCells =  (pos) ->
  	allNeighbourCells = [] 
  	allNeighbourCells[0] = {x:pos.x-1 , y:pos.y }
  	allNeighbourCells[1] = {x:pos.x+1 , y:pos.y }
  	allNeighbourCells[2] = {x:pos.x-1 , y:pos.y+1 }
  	allNeighbourCells[3] = {x:pos.x , y:pos.y-1 }
  	allNeighbourCells[4] = {x:pos.x , y:pos.y+1 }
  	allNeighbourCells[5] = {x:pos.x+1 , y:pos.y-1 }
  	allNeighbourCells  
