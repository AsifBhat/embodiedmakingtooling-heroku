jQuery ($) ->

  posid=0
  elemid=0

  EM_APP.grid.updatePosition = (obj, datum, dataset,posx,posy) ->
    pos = {x: posx, y:posy}
    existingPosition = EM_APP.vizdata.getPositionInCell(pos)
    EM_APP.util.consoleLog("Existing position")
    EM_APP.util.consoleLog(existingPosition)
    if(existingPosition  == '')
      position = { posId:posid, x:posx, y:posy, elementId:datum, description : " x: "+posx+", y: "+posy }
      posid = posid + 1
      EM_APP.vizdata.addPosition(position)
      EM_APP.util.consoleLog("Adding position")
      EM_APP.util.consoleLog(position)
    else
      position = { posId:existingPosition.posId, x:posx, y:posy, elementId:datum, description : " x: "+posx+", y: "+posy }
      EM_APP.vizdata.removePosition(existingPosition)
      EM_APP.vizdata.addPosition(position)

      
#----------------------------------------------------
  EM_APP.grid.deletePosition = (posx, posy) ->
    EM_APP.util.consoleLog("To delete"+posx+","+posy)
    todel = EM_APP.vizdata.getPositionInCell({x:posx,y:posy})
    EM_APP.util.consoleLog(todel)
    EM_APP.vizdata.removePosition(todel)
    currentCell = $(todel.posId)
    currentCell.removeClass('stories')
    currentCell.removeClass('forces')
    currentCell.removeClass('solutionComponents')
    currentCell.removeClass('new')
    currentCell.addClass('current')