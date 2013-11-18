jQuery ($) ->
  root = ''
  size = ''
  # Creating a grid
  AppContext.grid.createGrid = (domelem) ->
    AppContext.grid = hex.grid(domelem, {})
    size = hex.size(AppContext.grid.elem)
    AppContext.grid.reorient(size.x * 0.5, size.y * 0.5)
    root = $(AppContext.grid.root)
  
  AppContext.grid.createGrid($('#hexagonal-grid')[0])

  AppContext.grid.createHex = (styleClass, text = "") ->
    $("<div class='hex' >"+text+"</div>").css({
      "width": AppContext.grid.tileWidth + "px",
      "height": AppContext.grid.tileHeight + "px",
      "line-height": AppContext.grid.tileHeight + "px",
    }).addClass(styleClass)

    # Element to show the currently hovered tile
  hoveredElement = AppContext.grid.createHex('current')
  root.append(hoveredElement)
  idwithtooltip =  $('#desctooltip')
  idwithtooltip.css("width", size + "px")
  idwithtooltip.css("height", size + "px") 

   # Create new placeholder element to give a visual indication where we will be creating our new element
  newElement = AppContext.grid.createHex('new') 

  AppContext.grid.placeHex =(elem,x,y) ->
    inv = AppContext.grid.screenpos(x, y)
    elem.css("left", inv.x + "px")
    elem.css("top", inv.y + "px")

  AppContext.grid.showHoveredElement = (xc, yc) ->
    this.placeHex(hoveredElement,xc,yc)  

  AppContext.grid.placeNewElement = (xc, yc) ->
    this.placeHex(newElement,xc,yc)
    # Show the new element on the grid
    root.append(newElement)
    newElement

  # Placing tooltip if not an empty cell
  # elementid should be replaced with the content to be displayed in the tooltip.
  AppContext.grid.showTooltip = (x,y,tooltipInfo) ->
    inv = AppContext.grid.screenpos(x, y)
    idwithtooltip.attr("data-original-title",tooltipInfo+"<br/><button id='deleteButton' class='btn-mini'><span class='icon-remove remove_btn'></span></button>")
    idwithtooltip.css({
      "display": "",
      "left": (inv.x + AppContext.grid.origin.x) + "px",
      "top": (inv.y + AppContext.grid.origin.y) + "px"
    })
    $("#desctooltip").tooltip('show')
    $("#deleteButton").click((e) -> 
      AppContext.grid.deletePosition(parseInt(x,10),parseInt(y,10))
    )

  AppContext.grid.hideTooltip = () ->  
    $("#desctooltip").tooltip('hide')

  AppContext.grid.placeOnGrid = (elemwithpos) ->
    elemid = elemwithpos.elementId
    
    etype = elemid.substr(0,1)
    switch etype
      when 'S' then cls = "stories"
      when 'F' then cls = "forces"
      when 'C' then cls = "solutionComponents"
    
    cellToPlace = AppContext.grid.createHex(cls, elemid)
    $(cellToPlace).attr("id",elemwithpos.posId)
    root.append(cellToPlace)
    this.placeHex(cellToPlace,elemwithpos.x,elemwithpos.y)
    

  AppContext.grid.displayAllPositions = (positions) ->
    $('.forces, .solutionComponents, .stories').remove()
    $("#desctooltip").tooltip('hide')
    Util.log.console("Displaying all clusters")
    Util.log.console(positions)
    $.each(positions, (i, value) ->
      AppContext.grid.placeOnGrid (value)
    )

  AppContext.grid.getAllNeighbourCells =  (pos) ->
  	allNeighbourCells = [] 
  	allNeighbourCells[0] = {x:pos.x-1 , y:pos.y }
  	allNeighbourCells[1] = {x:pos.x+1 , y:pos.y }
  	allNeighbourCells[2] = {x:pos.x-1 , y:pos.y+1 }
  	allNeighbourCells[3] = {x:pos.x , y:pos.y-1 }
  	allNeighbourCells[4] = {x:pos.x , y:pos.y+1 }
  	allNeighbourCells[5] = {x:pos.x+1 , y:pos.y-1 }
  	allNeighbourCells  

  AppContext.grid.activateListeners = () ->
    # Setting mouse movement related tile events
    AppContext.grid.addEvent("tileover", (e, x, y) ->
      AppContext.grid.hoverEventHandler(e,x,y)   
    )

    # Tiletap is only fired when not dragging the grid
    AppContext.grid.addEvent("tiletap", (e, x, y) ->
      AppContext.grid.clickEventHandler(e,x,y)
    )
