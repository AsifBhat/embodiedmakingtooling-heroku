posid=0
elemid=0

AppContext.grid.updatePosition = (obj, datum, dataset,posx,posy) ->
  pos = {x: posx, y:posy}
  existingPosition = AppContext.vizdata.getPositionInCell(pos)
  Util.log.console("Existing position")
  Util.log.console(existingPosition)
  if(existingPosition  == '')
    position = { posId:posid, x:posx, y:posy, elementId:datum, description : " x: "+posx+", y: "+posy }
    posid = posid + 1
    AppContext.vizdata.addPosition(position)
    Util.log.console("Adding position")
    Util.log.console(position)
  else
    position = { posId:existingPosition.posId, x:posx, y:posy, elementId:datum, description : " x: "+posx+", y: "+posy }
    AppContext.vizdata.removePosition(existingPosition)
    AppContext.vizdata.addPosition(position)

    
#----------------------------------------------------
AppContext.grid.deletePosition = (posx, posy) ->
  Util.log.console("To delete"+posx+","+posy)
  todel = AppContext.vizdata.getPositionInCell({x:posx,y:posy})
  Util.log.console(todel)
  AppContext.vizdata.removePosition(todel)
  currentCell = $(todel.posId)
  currentCell.removeClass('stories')
  currentCell.removeClass('forces')
  currentCell.removeClass('solutionComponents')
  currentCell.removeClass('new')
  currentCell.addClass('current')