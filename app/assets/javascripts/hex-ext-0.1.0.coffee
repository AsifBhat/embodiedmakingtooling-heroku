jQuery ($) ->

  # Creating a grid
  gridElement = $('#hexagonal-grid')[0]
  EM_APP.grid = hex.grid(gridElement, {})
  size = hex.size(EM_APP.grid.elem)
  EM_APP.grid.reorient(size.x * 0.5, size.y * 0.5)
  root = $(EM_APP.grid.root)


  EM_APP.grid.createHex = (styleClass, text = "") ->
    $("<div class='hex' >"+text+"</div>").css({
      "width": EM_APP.grid.tileWidth + "px",
      "height": EM_APP.grid.tileHeight + "px",
      "line-height": EM_APP.grid.tileHeight + "px",
    }).addClass(styleClass)

    # Element to show the currently hovered tile
  hoveredElement = EM_APP.grid.createHex('current')
  root.append(hoveredElement)
  idwithtooltip =  $('#desctooltip')
  idwithtooltip.css("width", size + "px")
  idwithtooltip.css("height", size + "px") 

   # Create new placeholder element to give a visual indication where we will be creating our new element
  newElement = EM_APP.grid.createHex('new') 

  EM_APP.grid.placeHex =(elem,x,y) ->
    inv = EM_APP.grid.screenpos(x, y)
    elem.css("left", inv.x + "px")
    elem.css("top", inv.y + "px")

  EM_APP.grid.showHoveredElement = (xc, yc) ->
    this.placeHex(hoveredElement,xc,yc)  

  EM_APP.grid.placeNewElement = (xc, yc) ->
    this.placeHex(newElement,xc,yc)
    # Show the new element on the grid
    root.append(newElement)
    newElement

  # Placing tooltip if not an empty cell
  # elementid should be replaced with the content to be displayed in the tooltip.
  EM_APP.grid.showTooltip = (x,y,elementid) ->
    inv = EM_APP.grid.screenpos(x, y)
    typeind = elementid.substr(0,1)
    switch typeind
     when 'S' then etype = "stories"
     when 'F' then etype = "forces"
     when 'C' then etype = "solutionComponents"

    idwithtooltip.attr("data-original-title",elementid+"<br/><button id='deleteButton' class='btn-mini'><span class='icon-remove remove_btn'></span></button>")
    idwithtooltip.css({
      "display": "",
      "left": (inv.x + EM_APP.grid.origin.x) + "px",
      "top": (inv.y + EM_APP.grid.origin.y) + "px"
    })
    $("#desctooltip").tooltip('show')
    $("#deleteButton").click((e) -> 
      EM_APP.grid.deletePosition(parseInt(x,10),parseInt(y,10))
    )

  EM_APP.grid.hideTooltip = () ->  
    $("#desctooltip").tooltip('hide')

  EM_APP.grid.placeOnGrid = (elemwithpos) ->
    elemid = elemwithpos.elementId
    
    etype = elemid.substr(0,1)
    switch etype
      when 'S' then cls = "stories"
      when 'F' then cls = "forces"
      when 'C' then cls = "solutionComponents"
    
    cellToPlace = EM_APP.grid.createHex(cls, elemid)
    $(cellToPlace).attr("id",elemwithpos.posId)
    root.append(cellToPlace)
    this.placeHex(cellToPlace,elemwithpos.x,elemwithpos.y)
    

  EM_APP.grid.displayAllPositions = (positions) ->
    $('.forces, .solutionComponents, .stories').remove()
    $("#desctooltip").tooltip('hide')
    Util.log.console("Displaying all clusters")
    Util.log.console(positions)
    $.each(positions, (i, value) ->
      EM_APP.grid.placeOnGrid (value)
    )

  EM_APP.grid.getAllNeighbourCells =  (pos) ->
  	allNeighbourCells = [] 
  	allNeighbourCells[0] = {x:pos.x-1 , y:pos.y }
  	allNeighbourCells[1] = {x:pos.x+1 , y:pos.y }
  	allNeighbourCells[2] = {x:pos.x-1 , y:pos.y+1 }
  	allNeighbourCells[3] = {x:pos.x , y:pos.y-1 }
  	allNeighbourCells[4] = {x:pos.x , y:pos.y+1 }
  	allNeighbourCells[5] = {x:pos.x+1 , y:pos.y-1 }
  	allNeighbourCells  
