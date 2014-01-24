jQuery ($) ->
  context.init({
    fadeSpeed: 100,
    #filter: function ($obj){},
    above: 'auto',
    preventDoubleContext: true,
    compress: false
  });

  AppContext.grid.zoomValue = 3
  AppContext.grid.DEFAULT_ZOOM = 3
  AppContext.grid.MAX_ZOOM_LEVEL = 7
  AppContext.grid.MIN_ZOOM_LEVEL = 0
  AppContext.grid.ZOOM_ARRAY = [(1/3), (1/2), (2/3), 1 , 1.5, 2, 2.5]
  AppContext.grid.defaultSize = {
    width : 42,
    height: 48
  }

# Creating a grid
AppContext.grid.createGrid = (domelem) ->
  AppContext.grid.grid = hex.grid(domelem, {})
  AppContext.grid.size = hex.size(AppContext.grid.grid.elem)
  AppContext.grid.grid.size

AppContext.grid.createHex = (styleClass, text = "") ->
  $('<div class="hex '+ styleClass+'" >'+text+'</div>').css({
    'width': AppContext.grid.grid.tileWidth  + 'px',
    'height': (AppContext.grid.grid.tileHeight ) + 'px',
    'line-height': AppContext.grid.grid.tileHeight + 'px',
  }).addClass(styleClass)

AppContext.grid.addGridDomEventListeners = () ->
  $('#hexagonal-grid').bind('mousemove', AppContext.grid.mousemovehandler)
  $('#hexagonal-grid').bind('mousedown', AppContext.grid.mousedownhandler)


# initialize the hex grid
AppContext.grid.initialize = () ->
  AppContext.grid.hoveredElement = AppContext.grid.createHex('current')
  $(AppContext.grid.grid.root).append(AppContext.grid.hoveredElement)
  AppContext.grid.idwithtooltip =  $('#desctooltip')
  AppContext.grid.reorient()
  AppContext.grid.addGridDomEventListeners()
  AppContext.grid 

AppContext.grid.placeHex =(elem,x,y) ->
    inv = AppContext.grid.grid.screenpos(x, y)
    elem.css("left", inv.x + "px")
    elem.css("top", inv.y  + "px")
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
AppContext.grid.showTooltip = (x,y,elemId, tooltipInfo) ->
  inv = AppContext.grid.grid.screenpos(x, y)
  AppContext.grid.idwithtooltip.css({
    "left": ((inv.x + AppContext.grid.grid.origin.x) + 10) + "px",
    "top": (inv.y + AppContext.grid.grid.origin.y - 2) + "px",
    "z-index" : 10
  })
  tooltipHTML = '<textarea id="elemtext" class="elementsView" style="background-color:#555;width:90%;overflow:hidden;color:#FFF;font-size:10px;" onclick="$(this).autogrow()">' +
    tooltipInfo + 
    '</textarea><br><button class="btn-warning btn-mini" style="height: 20px;width: 20px;padding: 0px;" data-elementid="'+elemId+'" onclick="AppContext.cluster.deleteElem($(this))">' +
    '<span class="icon-remove remove_btn"></span></button>' +
    '&nbsp;&nbsp;&nbsp;<button class="btn-mini" data-elementid="'+elemId+'" onclick="AppContext.cluster.updateElem($(this))" style="height: 20px;width: 20px;padding: 0px;"><span class="icon-pencil"></span></button>' +
    '</textarea><hr style="margin-top:4px;margin-bottom:4px; padding:0px;"><button id="delposButton" btn-mini" style="height: 20px;width: 20px;padding: 0px;"><span class="icon-remove"></span></button>'
  AppContext.grid.idwithtooltip.tooltip('show')
  AppContext.grid.idwithtooltip.attr("data-original-title",tooltipHTML)
  #$('.elementsView').autogrow();
  $('.tooltip-inner').html(tooltipHTML)
  ###
  $("#delposButton").click(() -> 
    AppContext.cluster.deletePosition(parseInt(x,10),parseInt(y,10))
  )
  ###
  AppContext.grid.idwithtooltip

AppContext.grid.hideTooltip = () ->  
  AppContext.grid.idwithtooltip.tooltip('hide')

AppContext.grid.placeOnGrid = (elemwithpos, displaytext = "") ->
  elemid = elemwithpos.elementId
  if(displaytext == "") 
    displaytext = (AppContext.vizdata.getElementDescription(elemid)).substr(0,5)
  
  etype = elemid.substr(0,1)
  switch etype
    when 'S' then cls = "stories"
    when 'F' then cls = "forces"
    when 'C' then cls = "solutionComponents"
  
  cellToPlace = AppContext.grid.createHex(cls, displaytext)
  $(cellToPlace).attr("id",elemwithpos.posId)
  $(AppContext.grid.grid.root).append(cellToPlace)
  AppContext.grid.placeHex(cellToPlace,elemwithpos.x,elemwithpos.y)


AppContext.grid.removeFromGrid = (elemwithpos) ->
  domelem = $('#'+elemwithpos.posId)
  domelem.remove()

AppContext.grid.getGridPos = (e ) ->
  
  x = 0
  y = 0
  elem = $('#hexagonal-grid')[0]
  g = {x: AppContext.grid.grid.origin.x, y: AppContext.grid.grid.origin.y}  
  if (e.pageX != undefined && e.pageY != undefined)
    x = e.pageX;
    y = e.pageY;
  else if (e.clientX != undefined && e.clientY != undefined)
    x = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft
    y = e.clientY + document.body.scrollTop + document.documentElement.scrollTop
  if (elem) 
    zeropos = hex.position(elem)
    x = x - zeropos.x
    y = y - zeropos.y
  mousepos = {
    x: x,
    y: y
  }
  pos = {
    x: mousepos.x - g.x,
    y: mousepos.y - g.y
  }
  trans = AppContext.grid.grid.translate(pos.x, pos.y);
  trans


  
AppContext.grid.displayAllPositions = (positions) ->
  $('.forces, .solutionComponents, .stories').remove()
  $("#desctooltip").tooltip('hide')
  $.each(positions, (i, value) ->
    AppContext.grid.placeOnGrid (value)
  )
  context.attach('.hex', [{"text":"Select cluster","action":AppContext.grid.selectCluster}]);
  if($("#showborders").attr("value") == "hide")
    showborders()

AppContext.grid.clearGridCache = () ->
  AppContext.grid.size = ''
  AppContext.grid.hoveredElement = ''
  AppContext.grid.idwithtooltip = ''
  AppContext.grid.newElement = ''
  AppContext.grid.toDrag = []
  AppContext.grid.toDragRef = ''
  AppContext.grid.clonesToDrag = [] 
  AppContext.grid.toDragRefClone = ''
  AppContext.grid.selectedElemPos  = [] 
  AppContext.grid.rightClickedelempos = ''

AppContext.grid.getAllNeighbourCells =  (pos) ->
  allNeighbourCells = [] 
  allNeighbourCells[0] = {x:pos.x-1 , y:pos.y }
  allNeighbourCells[1] = {x:pos.x+1 , y:pos.y }
  allNeighbourCells[2] = {x:pos.x-1 , y:pos.y+1 }
  allNeighbourCells[3] = {x:pos.x , y:pos.y-1 }
  allNeighbourCells[4] = {x:pos.x , y:pos.y+1 }
  allNeighbourCells[5] = {x:pos.x+1 , y:pos.y-1 }
  allNeighbourCells  

AppContext.grid.initApp = () ->
  if($('#hexagonal-grid')[0]!=undefined)     
    AppContext.grid.createGrid($('#hexagonal-grid')[0])
    AppContext.grid.initialize()

AppContext.grid.activateListeners = () ->

  # Setting mouse movement related tile events
  AppContext.grid.grid.addEvent("tileover", AppContext.grid.hoverEventHandler)

  # Tiletap is only fired when not dragging the grid
  AppContext.grid.grid.addEvent("tiletap", AppContext.grid.clickEventHandler)

  AppContext.grid.grid.addEvent("tileout", AppContext.grid.hoveroutEventHandler)
  
  AppContext.grid.grid.addEvent("tiledown", AppContext.grid.tileDownHandler)
  
  AppContext.grid.grid.addEvent("tileup", AppContext.grid.tileUpHandler)
  
  AppContext.grid.grid.addEvent("tileclick", AppContext.grid.tileClickHandler)

  $('#nugget_btn').click((evt) ->
    AppContext.controls.handleNuggetDisplay(evt)
  )


AppContext.grid.activateZoomListeners = () ->

  $('#zoomin-controller').click( (evt) ->
    AppContext.grid.zoomEventHandler(evt, 1)
    #call the zoom handler with a positive value
  )

  $('#zoomout-controller').click( (evt) ->
    AppContext.grid.zoomEventHandler(evt, -1)
    #call the zoom handler with a negative value
  )

# draw the details about the element represented by the clicked element
AppContext.grid.drawTipDesc = (elementUnderMouse, description, pos) ->
  $('.cellTitle').text(elementUnderMouse)
  $('.cellDesc').text(description)
  $('#clickedLocation').text(pos.x + ',' + pos.y)
  AppContext.grid.drawTipHeader(elementUnderMouse)

# Draw the header for the edit section in case the clicked element is empty just render the overall summary
AppContext.grid.drawTipHeader = (elementId) ->
  cellTitleTxt = elementId
  if(elementId != '' && elementId != undefined)
    elemType = AppContext.vizdata.getContentElementType(cellTitleTxt)
    currentElementType = elemType
    cellTitleTxt = currentElementType + ': '+ cellTitleTxt
    $('.cellHeader').text(cellTitleTxt)
  else 
    AppContext.grid.drawMakingSummary()

AppContext.grid.drawMakingSummary = () ->
  nStories = AppContext.vizdata.getStories().length
  nForces = AppContext.vizdata.getForces().length
  nSolutions = AppContext.vizdata.getSolutions().length
  $('.cellHeader').text('Stories: ' + nStories + ' Forces: '+ nForces + ' Solutions: ' + nSolutions)


AppContext.grid.reorient = () ->
  AppContext.grid.grid.reorient(AppContext.grid.size.x * 0.5, AppContext.grid.size.y * 0.5)

AppContext.grid.hasOneEmptyNeighbour = (pos) ->
  emptynbs = false
  # If at least one of the neighbours of this cell is empty, the borders need to be marked
  allnbcells = AppContext.grid.getAllNeighbourCells(pos)
  $.each(allnbcells, (i, nbcell) ->
    nbposition = AppContext.vizdata.getPositionInCell(nbcell)
    if(AppContext.vizdata.isEmpty(nbposition))
      emptynbs = true
  )
  emptynbs
  

isTopEmpty = (posx, posy) ->
  AppContext.vizdata.isEmpty({x:posx, y:posy+1})

getBorderString = ( posx, posy) ->
  borders = []
  if(AppContext.vizdata.isEmpty({x:posx, y:posy+1}))
    Util.log.console("top")
    borders.push("27% 0%")
    borders.push("72% 0%") # show top border
  else  
    borders.push("27% 10%")
    borders.push("72% 10%") # hide top border
  
  if(AppContext.vizdata.isEmpty({x:posx+1, y:posy})) # show top right border
    Util.log.console("top right")
    borders.push("72% 0%") # start top right border
    borders.push("95% 45%") 
    borders.push("95% 50%") # stop top right border
  else # hide top right border
    borders.push("72% 10%")
    borders.push("90% 42%") 
    borders.push("90% 53%") 

  if(AppContext.vizdata.isEmpty({x:posx+1, y:posy-1}))
    Util.log.console("bottom right") 
    borders.push("95% 50%") # start bottom right border
    borders.push("72% 100%")
  else
    borders.push("90% 48%")
    borders.push("90% 52%")
    borders.push("68% 90%")  

  if(AppContext.vizdata.isEmpty({x:posx, y:posy-1}))
    Util.log.console("bottom")
    borders.push("72% 100%")
    borders.push("30% 100%")
  else
    borders.push("72% 90%")
    borders.push("32% 90%")  

  if(AppContext.vizdata.isEmpty({x:posx-1, y:posy}))
    Util.log.console("bottom left") 
    borders.push("30% 100%")  
    borders.push("3% 53%")
    borders.push("3% 50%")
  else
    borders.push("32% 90%")
    borders.push("10% 54%")
    
  if(AppContext.vizdata.isEmpty({x:posx-1, y:posy+1}))
    Util.log.console("top left")
    borders.push("0% 53%")
    borders.push("27% 0%")
  else
    borders.push("10% 45%")  
    borders.push("29% 10%")

  borders.join()


showborders = () ->
  allpositions = AppContext.vizdata.getPositions()
  $.each(allpositions, (i, position) ->
    domElem = $('#'+position.posId)
    pos = {x:position.x, y:position.y}
    emptynbs = AppContext.grid.hasOneEmptyNeighbour(pos)
    if(emptynbs)
      $(domElem).addClass("bordered")
    clip = getBorderString( pos.x, pos.y)  
    $(domElem).css("-webkit-clip-path","polygon("+clip+")")
  )   

#---------------------------------------------------------
# Should ideally update the extents of a cluster, surrounding the given posx and posy
# Now, all borders are being updated
AppContext.grid.markBorder = (posx, posy) ->
  borderbtn = $('#showborders')[0];
  action = $(borderbtn).attr("value");
  allpositions = AppContext.vizdata.getPositions()
  if(action == 'show')
    $(borderbtn).html('Hide Borders');
    $(borderbtn).attr("value","hide");    
    showborders()
  else
    $.each(allpositions, (i, position) ->
      domElem = $('#'+position.posId)
      $(domElem).removeClass("bordered")
      $(domElem).css("-webkit-clip-path","")
    ) 
    $(borderbtn).html('Show Borders');
    $(borderbtn).attr("value","show");
  
jQuery ($) ->
  AppContext.grid.clearGridCache()
  AppContext.grid.contextmenu = context.init({
    fadeSpeed: 100,
    #filter: function ($obj){},
    above: 'auto',
    preventDoubleContext: true,
    compress: false
  });

