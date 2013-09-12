jQuery ($) ->

posBeforeTranslation = []
placed = []
rootElement = ''
currentCluster = ''

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
   relatedToCurrent = getRelatedElements(p.elem)
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
 console.log("All neighbour cells for"+pos.x+pos.y)
 console.log(allNeighbourCells)
 allNeighbourCells


getIntersect = (allNeighbourCells) ->
 tempInt = []
 $.each(allNeighbourCells, (i, nb) ->
  $.each(intersectingNeighbourhood, (j, intersect) ->
   if(nb.x==intersect.x) && (nb.y == intersect.y)
    console.log("Int found")
    tempInt.push({x:nb.x,y:nb.y})
   else
    #console.log("Int not found")
    #console.log(nb) 
  )
 )   
 console.log("Result of intersect:")
 console.log(tempInt)
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
  console.log("getIntersectingEmptyNeighbourhood:mergedlist:"+mergedList)
  $.each(mergedList , (i,r) ->
    pos = getPlacedPosition(r)
    allNeighbourCells = getAllNeighbourCells(pos)
    if(i==0)
     intersectingNeighbourhood = allNeighbourCells
    intersectingNeighbourhood = getIntersect(allNeighbourCells)
    console.log("getIntersectingEmptyNeighbourhood:intersectingNeighbourhood:")
    console.log(intersectingNeighbourhood)
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
  
place = (relElem,pos) ->
 console.log("x,y ")
 console.log(pos)
 posBeforeTranslation.push({"coord" : {x:pos.x, y:pos.y} , "elem" : relElem})
 placed.push({"elem" : relElem , "coord" : {x:pos.x, y:pos.y}})
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
 console.log(gridElement)
 root.append(cellToPlace)
 placeHex(cellToPlace,grid,pos.x,pos.y)
 
 
   
placeNewElement = (relElem) ->
 # Check related elements of all placed elements.  See if current element is present in any of those lists
   getListOfRelatedPlacedElements(relElem)
 # Check related element list of current element.  See if any of the placed elements are in this list
   getListOfPlacedRelatedElements(relElem) 
 # Merge two lists 
   console.log("Two lists to merge: "+listOfRelatedPlacedElements+" and "+listOfPlacedRelatedElements)
   mergedList = $.merge( $.merge([],listOfRelatedPlacedElements), listOfPlacedRelatedElements)
   mergedList.push(rootElement)
   console.log("merged "+listOfRelatedPlacedElements+ " and " + listOfPlacedRelatedElements+" to get "+mergedList + " for "+ relElem)
   emptyIntersectingNeighbourhood = getIntersectingEmptyNeighbourhood($.unique(mergedList))
   console.log("Empty intersecting neighbourhood:")
   console.log(emptyIntersectingNeighbourhood)
   place(relElem, emptyIntersectingNeighbourhood[0])
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
 place(rootElement,{x:0,y:0})
 $.each(graph, (i,value) ->
  console.log(value.element+" -> "+value.relatedElements)
  rootElement = value.element
  placeElements(value.relatedElements)
  console.log("---------") 
 ) 

displayAllClusters = (clustersJson) ->
  currentCluster = clustersJson.clusters[0].graph
  displayCluster(currentCluster)

clustersRequest = $.getJSON "/api/clusters"
clustersRequest.success (data) ->
 displayAllClusters(data)
 
 