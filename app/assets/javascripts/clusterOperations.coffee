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
 # Temporary variables
posid=0
elemid=0
x=0

isEmpty = (pos) ->
 empty = true
 $.each(window.global_vizdata, (i,position) ->
  if (position.x == pos.x) && (position.y == pos.y)  
    empty = false
 )	
 empty	
 
window.getElementInCell = (pos) ->
 elem = ''
 $.each(window.global_vizdata.getPositions(), (i,position) ->
  if (position.x == pos.x) && (position.y == pos.y)  
    elem = position.elementId
 )
 elem

getPositionInCell = (pos) ->
  positionToReturn = ''
  $.each(window.global_vizdata.getPositions(), (i,position) ->
    if (position.x == pos.x) && (position.y == pos.y)  
      positionToReturn = position
  )
  positionToReturn

#-------------------------------------------------------------------------------------- 
# Update positions should call the addPos method of VizDataModel to add a new enty.
# The update and delete methods for the positions are yet to be written.
# We could either have two separate calls from here to update positions and relations or 
# let the position methods call the relations methods.
window.updatePositions = (obj, datum, dataset,posx,posy) ->
  pos = {x: posx, y:posy}
  existingPosition = getPositionInCell(pos)
  consoleLog("Existing position")
  consoleLog(existingPosition)
  if( existingPosition == '')
    position = { posId:posid, x:posx, y:posy, elementId:datum, description : " x: "+posx+", y: "+posy }
    posid = posid + 1
    window.global_vizdata.addPosition(position)
    consoleLog("Adding position")
    consoleLog(position)
  else
    position = { posId:existingPosition.posId, x:posx, y:posy, elementId:datum, description : " x: "+posx+", y: "+posy }
    window.global_vizdata.removePosition(existingPosition)
    window.global_vizdata.addPosition(position)

    
#----------------------------------------------------

window.deletePosition = (posx, posy) ->
  consoleLog("To delete"+posx+","+posy)
  todel = getPositionInCell({x:posx,y:posy})
  consoleLog(todel)
  window.global_vizdata.removePosition(todel)
  currentCell = $(todel.posId)
  currentCell.removeClass('stories')
  currentCell.removeClass('forces')
  currentCell.removeClass('solutionComponents')
  currentCell.removeClass('new')
  currentCell.addClass('current')