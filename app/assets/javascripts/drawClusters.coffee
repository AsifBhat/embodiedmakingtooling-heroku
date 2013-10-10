jQuery ($) ->

window.posOnGrid = []

createHex = (styleClass,text) ->
    $("<div class='hex' >"+text+"</div>").css({
      "width": "48px",
      "height": "42px",
      "line-height":  "48px",
    }).addClass(styleClass)
    
placeHex =(elem,grid,x,y) ->
    inv = grid.screenpos(x, y)
    elem.css("left", inv.x + "px")
    elem.css("top", inv.y + "px")
 
placeOnGrid = (elemwithpos) ->
  elemid = elemwithpos.elementId
  etype = elemid.substr(0,1)
  switch etype
   when 'S' then cls = "stories"
   when 'F' then cls = "forces"
   when 'C' then cls = "solutionComponents"
  cellToPlace = createHex(cls,elemid)
  gridElement = $('#hexagonal-grid')[0]
  grid = hex.grid(gridElement, {})
  root = $(grid.root)
  root.append(cellToPlace)
  placeHex(cellToPlace,grid,elemwithpos.xPos,elemwithpos.yPos)
  window.posOnGrid.push({ "posId": elemwithpos.posId, "elementId" : elemwithpos.elementId, "clusterId" :elemwithpos.clusterId , "xPos" : elemwithpos.xPos, "yPos": elemwithpos.yPos })
 
displayAllClusters = (clustersJson) ->
  $.each(clustersJson, (i, value) ->
   placeOnGrid (value)
  )
 
clusterPosRequest = $.getJSON "/api/positions"
clusterPosRequest.success (data) ->
  clustersPosJson = data
  consoleLog(data)
  displayAllClusters(clustersPosJson)
