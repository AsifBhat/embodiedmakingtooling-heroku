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
  idwithtooltip =  $('<div id="desctooltip" data-html="true" data-trigger="focus" style="z-index:1000;width:40px;height:40px;opacity:.5;position:absolute;" data-placement="top" type="button"></div>')
  idwithtooltip.css("width", size + "px")
  idwithtooltip.css("height", size + "px")  

  EM_APP.grid.placeHex =(elem,x,y) ->
    inv = EM_APP.grid.screenpos(x, y)
    elem.css("left", inv.x + "px")
    elem.css("top", inv.y + "px")

  # Placing tooltip if not an empty cell
  # elementid should be replaced with the content to be displayed in the tooltip.
  EM_APP.grid.placeTooltip = (x,y,elementid) ->
    EM_APP.util.consoleLog 'cell tool tip triggered : ' + elementid
    inv = EM_APP.grid.screenpos(x, y)
    typeind = elementid.substr(0,1)
    switch typeind
     when 'S' then etype = "stories"
     when 'F' then etype = "forces"
     when 'C' then etype = "solutionComponents"

    idwithtooltip.attr("data-original-title",elementid+"<br/><button style='z-index:1000;font-size:1em;' id='deleteButton' class='btn-mini'><span class='icon-remove remove_btn'></span></button>")
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
      EM_APP.util.consoleLog 'tooltip clicked'
    )
    $("#deleteButton").click((e) -> 
      e.stopPropagation()
      EM_APP.util.consoleLog 'delete triggered'
      $("#content-search").css("display","none")
      window.deletePosition(parseInt(x,10),parseInt(y,10))
    )

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
    placeHex(cellToPlace,elemwithpos.x,elemwithpos.y)
    

  EM_APP.grid.displayAllPositions = (positions) ->
    EM_APP.util.consoleLog("Displaying all clusters")
    EM_APP.util.consoleLog(positions)
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