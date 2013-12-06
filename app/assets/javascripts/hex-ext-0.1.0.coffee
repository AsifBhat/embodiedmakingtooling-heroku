# Creating a grid
AppContext.grid.createGrid = (domelem) ->
  AppContext.grid.grid = hex.grid(domelem, {})
  AppContext.grid.size = hex.size(AppContext.grid.grid.elem)
  AppContext.grid.grid.reorient(AppContext.grid.size.x * 0.5, AppContext.grid.size.y * 0.5)
  AppContext.grid.grid.size

AppContext.grid.createHex = (styleClass, text = "") ->
  $("<div class='hex' >"+text+"</div>").css({
    "width": AppContext.grid.grid.tileWidth + "px",
    "height": AppContext.grid.grid.tileHeight + "px",
    "line-height": AppContext.grid.grid.tileHeight + "px",
  }).addClass(styleClass)

AppContext.grid.initialize = () ->
  AppContext.grid.hoveredElement = AppContext.grid.createHex('current')
  $(AppContext.grid.grid.root).append(AppContext.grid.hoveredElement)
  AppContext.grid.idwithtooltip =  $('#desctooltip')
  AppContext.grid.idwithtooltip.css("width", AppContext.grid.grid.tileWidth + "px")
  AppContext.grid.idwithtooltip.css("height", AppContext.grid.grid.tileHeight + "px")   
  AppContext.grid 
  # Should we somehow move content assisst here? 

AppContext.grid.placeHex =(elem,x,y) ->
    inv = AppContext.grid.grid.screenpos(x, y)
    elem.css("left", inv.x + "px")
    elem.css("top", inv.y + "px")
    elem

AppContext.grid.showHoveredElement = (xc, yc) ->
  AppContext.grid.placeHex(AppContext.grid.hoveredElement,xc,yc)  
  AppContext.grid.hoveredElement

AppContext.grid.placeNewElement = (xc, yc) ->
  AppContext.grid.newElement = AppContext.grid.createHex('new') 
  AppContext.grid.placeHex(AppContext.grid.newElement,xc,yc)
  # Show the new element on the grid
  $(AppContext.grid.grid.root).append(AppContext.grid.newElement)
  AppContext.grid.newElement

# Placing tooltip if not an empty cell
# elementid should be replaced with the content to be displayed in the tooltip.
AppContext.grid.showTooltip = (x,y,tooltipInfo) ->
  inv = AppContext.grid.grid.screenpos(x, y)
  AppContext.grid.idwithtooltip.css({
    "left": (inv.x + AppContext.grid.grid.origin.x) + "px",
    "top": (inv.y + AppContext.grid.grid.origin.y) + "px",
    "z-index" : 10
  })
  tooltipHTML = tooltipInfo+'<br><button class="deleteButton btn-mini"><span class="icon-remove remove_btn"></span></button>'
  AppContext.grid.idwithtooltip.tooltip('show')
  AppContext.grid.idwithtooltip.attr("data-original-title",tooltipHTML)
  $('.tooltip-inner').html(tooltipHTML)
  $(".deleteButton").click(() -> 
    AppContext.grid.deletePosition(parseInt(x,10),parseInt(y,10))
  )
  AppContext.grid.idwithtooltip

AppContext.grid.hideTooltip = () ->  
  AppContext.grid.idwithtooltip.tooltip('hide')

AppContext.grid.placeOnGrid = (elemwithpos) ->
  elemid = elemwithpos.elementId
  
  etype = elemid.substr(0,1)
  switch etype
    when 'S' then cls = "stories"
    when 'F' then cls = "forces"
    when 'C' then cls = "solutionComponents"
  
  cellToPlace = AppContext.grid.createHex(cls, elemid)
  $(cellToPlace).attr("id",elemwithpos.posId)
  $(AppContext.grid.grid.root).append(cellToPlace)
  AppContext.grid.placeHex(cellToPlace,elemwithpos.x,elemwithpos.y)
  

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
  AppContext.grid.grid.addEvent("tileover", (e, x, y) ->
    AppContext.grid.hoverEventHandler(e,x,y)   
  )

  # Tiletap is only fired when not dragging the grid
  AppContext.grid.grid.addEvent("tiletap", (e, x, y) ->
    AppContext.grid.clickEventHandler(e,x,y)
  )

  AppContext.grid.grid.addEvent("tileout", (e, x, y) ->
    AppContext.grid.hoveroutEventHandler(e, x, y)
  )

jQuery ($) ->
  #root = ''
  AppContext.grid.size = ''
  AppContext.grid.hoveredElement = ''
  AppContext.grid.idwithtooltip = ''
  AppContext.grid.newElement = ''
  if($('#hexagonal-grid')[0]!=undefined)     
    AppContext.grid.createGrid($('#hexagonal-grid')[0])
    AppContext.grid.initialize()
  
  