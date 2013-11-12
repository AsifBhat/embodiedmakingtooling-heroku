jQuery ($) ->

  # Creating a grid
  gridElement = $('#hexagonal-grid')[0]
  grid = hex.grid(gridElement, {})
  size = hex.size(grid.elem)
  grid.reorient(size.x * 0.5, size.y * 0.5)
  root = $(grid.root)

  
  # Element to show the currently hovered tile
  hoveredElement = createHex('current')
  root.append(hoveredElement)
  idwithtooltip =  $('<div id="desctooltip" data-html="true" data-trigger="focus" style="z-index:1000;width:40px;height:40px;opacity:.5;position:absolute;" data-placement="top" type="button"></div>')
  idwithtooltip.css("width", size + "px")
  idwithtooltip.css("height", size + "px")


  createHex = (styleClass, text = "") ->
    $("<div class='hex' >"+text+"</div>").css({
      "width": grid.tileWidth + "px",
      "height": grid.tileHeight + "px",
      "line-height": grid.tileHeight + "px",
    }).addClass(styleClass)

  placeHex =(elem,x,y) ->
    inv = grid.screenpos(x, y)
    elem.css("left", inv.x + "px")
    elem.css("top", inv.y + "px")

  # Placing tooltip if not an empty cell
  # elementid should be replaced with the content to be displayed in the tooltip.
  placeTooltip = (x,y,elementid) ->
    consoleLog 'cell tool tip triggered : ' + elementid
    inv = grid.screenpos(x, y)
    typeind = elementid.substr(0,1)
    switch typeind
     when 'S' then etype = "stories"
     when 'F' then etype = "forces"
     when 'C' then etype = "solutionComponents"

    idwithtooltip.attr("data-original-title",window.getElementDescription(elementid)+"<br/><button style='z-index:1000;font-size:1em;' id='deleteButton' class='btn-mini'><span class='icon-remove remove_btn'></span></button>")
    root.append(idwithtooltip)

    idwithtooltip.css("left", inv.x + "px")
    idwithtooltip.css("top", inv.y+15 + "px")
    #$("#desctooltip").tooltip({delay: 500})
    $("#desctooltip").tooltip('show')
    
    $('.tooltip').mouseenter((e)->
      e.stopPropagation()
      #$("#desctooltip").tooltip('show')
    )
    $('.tooltip').mouseleave((e)->
      e.stopPropagation()
      #$("#desctooltip").tooltip('hide');
    )
    $(".tooltip").click((e) -> 
      #window.deleteContentElement(parseInt(x,10),parseInt(y,10))
      e.stopPropagation()
      consoleLog 'tooltip clicked'
    )
    $("#deleteButton").click((e) -> 
      e.stopPropagation()
      consoleLog 'delete triggered'
      $("#content-search").css("display","none")
      window.deletePosition(parseInt(x,10),parseInt(y,10))
    )

  placeOnGrid = (elemwithpos) ->
    elemid = elemwithpos.elementId
    
    etype = elemid.substr(0,1)
    switch etype
      when 'S' then cls = "stories"
      when 'F' then cls = "forces"
      when 'C' then cls = "solutionComponents"
    
    cellToPlace = createHex(cls, elemid)
    $(cellToPlace).attr("id",elemwithpos.posId)
    root.append(cellToPlace)
    placeHex(cellToPlace,elemwithpos.x,elemwithpos.y)
    

  window.displayAllPositions = (positions) ->
    consoleLog("Displaying all clusters")
    consoleLog(positions)
    $.each(positions, (i, value) ->
      placeOnGrid (value)
    )

  getAllNeighbourCells =  (pos) ->
	allNeighbourCells = [] 
	allNeighbourCells[0] = {x:pos.x-1 , y:pos.y }
	allNeighbourCells[1] = {x:pos.x+1 , y:pos.y }
	allNeighbourCells[2] = {x:pos.x-1 , y:pos.y+1 }
	allNeighbourCells[3] = {x:pos.x , y:pos.y-1 }
	allNeighbourCells[4] = {x:pos.x , y:pos.y+1 }
	allNeighbourCells[5] = {x:pos.x+1 , y:pos.y-1 }
	allNeighbourCells  