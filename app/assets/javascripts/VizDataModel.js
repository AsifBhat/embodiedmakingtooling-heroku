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

window.getElementDescription = (elementId) ->
  description = ''
  $.each(window.global_vizdata.getElements(), (i, element)->
    if(element.elementId == elementId)
      description = element.description
      return
  )
  description