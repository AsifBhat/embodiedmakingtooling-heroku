jQuery ($) ->


getAllNeighbourCells =  (pos) ->
 allNeighbourCells = [] 
 allNeighbourCells[0] = {x:pos.x-1 , y:pos.y }
 allNeighbourCells[1] = {x:pos.x+1 , y:pos.y }
 allNeighbourCells[2] = {x:pos.x-1 , y:pos.y+1 }
 allNeighbourCells[3] = {x:pos.x , y:pos.y-1 }
 allNeighbourCells[4] = {x:pos.x , y:pos.y+1 }
 allNeighbourCells[5] = {x:pos.x+1 , y:pos.y-1 }
 allNeighbourCells
 
isEmpty = (pos) ->
 empty = true
 $.each(window.posOnGrid, (i,position) ->
  if (position.xPos == pos.x) && (position.yPos == pos.y)  
    empty = false
 )	
 empty	
 
window.getElementInCell = (pos) ->
 elem = ''
 $.each(window.posOnGrid, (i,position) ->
  if (position.xPos == pos.x) && (position.yPos == pos.y)  
    elem = position.elementId
 )	 
 elem
 
getClusterInCell = (pos) ->
 cluster = ''
 $.each(window.posOnGrid, (i,position) ->
  if (position.xPos == pos.x) && (position.yPos == pos.y)  
    cluster = position.clusterId  
 )	 
 cluster

 #-------------------------------------------------------------------------------------- 
# Update positions should call the addPos method of VizDataModel to add a new enty.
# The update and delete methods for the positions are yet to be written.
# We could either have two separate calls from here to update positions and relations or 
# let the position methods call the relations methods.
window.updatePositions = (obj, datum, dataset,posx,posy) ->
    
#----------------------------------------------------