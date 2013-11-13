jQuery ($) ->

  posid=0
  elemid=0

  appContext.grid.updatePosition = (obj, datum, dataset,posx,posy) ->
    pos = {x: posx, y:posy}
    existingPosition = appContext.vizdata.getPositionInCell(pos)
    Util.log.console("Existing position")
    Util.log.console(existingPosition)
    if(existingPosition  == '')
      position = { posId:posid, x:posx, y:posy, elementId:datum, description : " x: "+posx+", y: "+posy }
      posid = posid + 1
      appContext.vizdata.addPosition(position)
      Util.log.console("Adding position")
      Util.log.console(position)
    else
      position = { posId:existingPosition.posId, x:posx, y:posy, elementId:datum, description : " x: "+posx+", y: "+posy }
      appContext.vizdata.removePosition(existingPosition)
      appContext.vizdata.addPosition(position)

      
#----------------------------------------------------
  appContext.grid.deletePosition = (posx, posy) ->
    Util.log.console("To delete"+posx+","+posy)
    todel = appContext.vizdata.getPositionInCell({x:posx,y:posy})
    Util.log.console(todel)
    appContext.vizdata.removePosition(todel)
    currentCell = $(todel.posId)
    currentCell.removeClass('stories')
    currentCell.removeClass('forces')
    currentCell.removeClass('solutionComponents')
    currentCell.removeClass('new')
    currentCell.addClass('current')