jQuery ($) ->

posBeforeTranslation = []
placed = []
rootElement = ''
currentCluster = ''


# Variables required for translation of the cluster with origin 0,0 to a different area on the grid

# Determines which quadrant the cluster will be displayed
QUAD = 0

# Current boundary of the used area along the x-axis
NEG_X_BOUND = 0
POS_X_BOUND = 0

# Current boundary of the used area along the y-axis
NEG_Y_BOUND = 0
POS_Y_BOUND = 0

# Extents of the current cluster
NEG_X_EXTENT = 0
POS_X_EXTENT = 0
NEG_Y_EXTENT = 0
POS_Y_EXTENT = 0
x_offset = 0
y_offset = 0

calcOffsets = (a) ->
 switch QUAD
  when 0 
   x_offset = POS_X_BOUND + 1 - NEG_X_EXTENT
   y_offset = POS_Y_BOUND + 1 - NEG_Y_EXTENT
  when 1 
   x_offset = POS_X_BOUND + 1 - NEG_X_EXTENT
   y_offset = NEG_Y_BOUND - 1 - POS_Y_EXTENT
  when 2
   x_offset = NEG_X_BOUND - 1 - POS_X_EXTENT
   y_offset = NEG_Y_BOUND - 1 - POS_Y_EXTENT
  when 3 
   x_offset = NEG_X_BOUND - 1 - POS_X_EXTENT
   y_offset = POS_Y_BOUND + 1 - NEG_Y_EXTENT
 console.log("Quad:"+QUAD+", Offsets:"+x_offset+","+y_offset)
  
resetUsedAreaBoundaries = (posOnGrid) ->
 if (posOnGrid.x < 0) && (posOnGrid.x < NEG_X_BOUND)
  NEG_X_BOUND = posOnGrid.x
 if (posOnGrid.x > 0) && (posOnGrid.x > POS_X_BOUND)
  POS_X_BOUND = posOnGrid.x
 if (posOnGrid.y < 0) && (posOnGrid.y < NEG_Y_BOUND)
  NEG_Y_BOUND = posOnGrid.y
 if (posOnGrid.y > 0) && (posOnGrid.y > POS_Y_BOUND)
  POS_Y_BOUND = posOnGrid.y  
 console.log("Reset used area:"+NEG_X_BOUND+","+POS_X_BOUND+","+NEG_Y_BOUND+","+POS_Y_BOUND)
  
 
getOffsetPos = (pos) -> 
 newPos = { x:pos.x+x_offset, y:pos.y+y_offset }
 newPos
 
# Reset positioning variables after each cluster is displayed
resetVariables = (a) ->
 QUAD = (QUAD + 1) % 4
 NEG_X_EXTENT = 0
 POS_X_EXTENT = 0
 NEG_Y_EXTENT = 0
 POS_Y_EXTENT = 0
 x_offset = 0
 y_offset = 0
 placed = []
 posBeforeTranslation.length = []
 

initPos = (link) ->
 rootElement = link.element
 posBeforeTranslation.push({ "coord" : {x:0, y:0} , "elem" : rootElement})
 placed.push({ "elem" : rootElement, "coord" : {x:0 , y:0}})
 
isPlaced = (elem) ->
 isPresent = false
 $.each(placed, (i,p) ->
  if p.elem == elem
   isPresent = true
 )
 isPresent

listOfRelatedPlacedElements = []

getRelatedElements = (elem) ->
 r=''
 $.each(currentCluster, (i,value) ->
  if(value.element == elem)
   r = value.relatedElements
 )  
 r   

getListOfRelatedPlacedElements = (elem) ->
 $.each(placed, (i,p) ->
   relatedToPlaced = getRelatedElements(p.elem)
   $.each(relatedToPlaced, (j,value) ->
    if(elem == value)&& (rootElement!=p.elem)
     listOfRelatedPlacedElements.push(p.elem)
   )
  ) 
 
listOfPlacedRelatedElements = []
 
getListOfPlacedRelatedElements = (elem) ->
  $.each(placed , (i,p) ->
   relatedToCurrent = getRelatedElements(elem)
   $.each(relatedToCurrent, (j,r) ->
    if(p.elem == r )
     listOfPlacedRelatedElements.push(p.elem)
   )
  )
  
intersectingNeighbourhood = []
  
getPlacedPosition = (r) ->
  pos = {x:0,y:0}
  $.each(placed, (i,p) ->
     if(p.elem == r)
       pos.x = p.coord.x
       pos.y = p.coord.y
  )  
  pos
  
getAllNeighbourCells =  (pos) ->
 console.log(pos)
 allNeighbourCells = [] 
 allNeighbourCells[0] = {x:pos.x-1 , y:pos.y }
 allNeighbourCells[1] = {x:pos.x+1 , y:pos.y }
 allNeighbourCells[2] = {x:pos.x-1 , y:pos.y+1 }
 allNeighbourCells[3] = {x:pos.x , y:pos.y-1 }
 allNeighbourCells[4] = {x:pos.x , y:pos.y+1 }
 allNeighbourCells[5] = {x:pos.x+1 , y:pos.y-1 }
 allNeighbourCells


getIntersect = (allNeighbourCells) ->
 tempInt = []
 $.each(allNeighbourCells, (i, nb) ->
  $.each(intersectingNeighbourhood, (j, intersect) ->
   if(nb.x==intersect.x) && (nb.y == intersect.y)
    tempInt.push({x:nb.x,y:nb.y})
  )
 )   
 tempInt   

isEmpty = (pos) ->
 empty = true
 $.each(posBeforeTranslation, (i,position) ->
  if (position.coord.x == pos.x) && (position.coord.y == pos.y)  
    empty = false
 )	
 empty	
	
	
getEmptyIntersect = (intersectingNeighbourhood) ->
    emptyIntersectingNeighbourhood = []
    $.each(intersectingNeighbourhood, (i,pos) ->
      if isEmpty(pos)
       emptyIntersectingNeighbourhood.push(pos)
    )
    emptyIntersectingNeighbourhood
     
  
getIntersectingEmptyNeighbourhood = (mergedList) ->
  $.each(mergedList , (i,r) ->
    pos = getPlacedPosition(r)
    allNeighbourCells = getAllNeighbourCells(pos)
    if(i==0)
     intersectingNeighbourhood = allNeighbourCells
    intersectingNeighbourhood = getIntersect(allNeighbourCells)
  )
  getEmptyIntersect(intersectingNeighbourhood)
  
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
  
placeInMem = (relElem,pos) ->
 console.log("x,y ")
 console.log(pos)
 posBeforeTranslation.push({"coord" : {x:pos.x, y:pos.y} , "elem" : relElem})
 placed.push({"elem" : relElem , "coord" : {x:pos.x, y:pos.y}})
 if pos.x<0 && pos.x<NEG_X_EXTENT
  NEG_X_EXTENT = pos.x
 if pos.x>0 && pos.x>POS_X_EXTENT
  POS_X_EXTENT = pos.x
 if pos.y<0 && pos.y<NEG_Y_EXTENT
  NEG_Y_EXTENT = pos.y
 if pos.y>0 && pos.y>POS_Y_EXTENT
  POS_Y_EXTENT = pos.y 
 console.log("Placed in memory:"+relElem+"EXTENTS:"+ NEG_X_EXTENT+","+POS_X_EXTENT+","+NEG_Y_EXTENT+","+POS_Y_EXTENT)
  
 
placeOnGrid = (a) ->
 console.log("Inside place on grid")
 calcOffsets('a')
 $.each(placed, (i,p) -> 
  relElem = p.elem
  etype = relElem.substr(0,1)
  switch etype
   when 'S' then cls = "stories"
   when 'F' then cls = "forces"
   when 'C' then cls = "solutionComponents"
  cellToPlace = createHex(cls,relElem)
  # gridElement = $("div","#hexagonal-grid")[0]
  # root = $(gridElement.root)
  gridElement = $('#hexagonal-grid')[0]
  grid = hex.grid(gridElement, {})
  root = $(grid.root)
  root.append(cellToPlace)
  posOnGrid = getOffsetPos(p.coord)
  # console.log("Got offset pos:"+posOnGrid.x+","+posOnGrid.y+" for pos:"+p.coord.x+","+p.coord.y)
  placeHex(cellToPlace,grid,posOnGrid.x,posOnGrid.y)
  resetUsedAreaBoundaries(posOnGrid)
 ) 
 
getEmptyNBcount = (pos) ->
 allnb = getAllNeighbourCells(pos)
 numEmpty = 0
 $.each(allnb, (i, nb) ->
  if isEmpty(nb)
   numEmpty = numEmpty + 1
 )
 numEmpty  
 
getUniqueNeighbourhood = ( nbhood, nbCount) ->
 toReturn = {x:0,y:0}
 $.each(nbhood, (i, nb) ->
  if getEmptyNBcount(nb) == nbCount
   toReturn = {x:nb.x,y:nb.y}    
 )
 toReturn
   
placeNewElement = (relElem) ->
 # Check related elements of all placed elements.  See if current element is present in any of those lists
   getListOfRelatedPlacedElements(relElem)
 # Check related element list of current element.  See if any of the placed elements are in this list
   getListOfPlacedRelatedElements(relElem) 
 # Merge two lists 
   mergedList = $.merge( $.merge([],listOfRelatedPlacedElements), listOfPlacedRelatedElements)
   mergedList.push(rootElement)
   emptyIntersectingNeighbourhood = getIntersectingEmptyNeighbourhood($.unique(mergedList))
   emptyNBcnt = 6 - ($.unique(mergedList).length )
   console.log("empty neighbour cell count should be:"+emptyNBcnt)
   finalMemPos = getUniqueNeighbourhood(emptyIntersectingNeighbourhood, emptyNBcnt)
   placeInMem(relElem, finalMemPos)
   listOfRelatedPlacedElements.length = 0
   intersectingNeighbourhood.length = 0
   listOfPlacedRelatedElements.length = 0
 
 
placeElements = (relatedElements) ->
 $.each(relatedElements, (i,relElem) ->
  if isPlaced relElem
   console.log("Already Placed "+relElem)
  else 
   console.log("Not Placed "+relElem)
   placeNewElement(relElem)
 )
     
 

displayCluster = (graph) ->
 rootElement = graph[0].element
 placeInMem(rootElement,{x:0,y:0})
 $.each(graph, (i,value) ->
  console.log(value.element+" -> "+value.relatedElements)
  rootElement = value.element
  placeElements(value.relatedElements)
  console.log("---------") 
 ) 
 

displayAllClusters = (clustersJson) ->
  $.each(clustersJson.clusters, (i, value) ->
   currentCluster = value.graph
   displayCluster(currentCluster)
   placeOnGrid ('a')
   resetVariables ('a')
   console.log("---------") 
   console.log("---------")  
  ) 

clustersRequest = $.getJSON "/api/clusters"
clustersRequest.success (data) ->
 displayAllClusters(data)
 
 