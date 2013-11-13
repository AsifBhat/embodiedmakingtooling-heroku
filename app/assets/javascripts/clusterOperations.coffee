jQuery ($) ->

  posid=0
  elemid=0

  EM_APP.grid.updatePosition = (obj, datum, dataset,posx,posy) ->
    pos = {x: posx, y:posy}
    existingPosition = EM_APP.vizdata.getPositionInCell(pos)
    Util.log.console("Existing position")
    Util.log.console(existingPosition)
    if(existingPosition  == '')
      position = { posId:posid, x:posx, y:posy, elementId:datum, description : " x: "+posx+", y: "+posy }
      posid = posid + 1
      EM_APP.vizdata.addPosition(position)
      Util.log.console("Adding position")
      Util.log.console(position)
    else
      position = { posId:existingPosition.posId, x:posx, y:posy, elementId:datum, description : " x: "+posx+", y: "+posy }
      EM_APP.vizdata.removePosition(existingPosition)
      EM_APP.vizdata.addPosition(position)

      
#----------------------------------------------------
  EM_APP.grid.deletePosition = (posx, posy) ->
    Util.log.console("To delete"+posx+","+posy)
    todel = EM_APP.vizdata.getPositionInCell({x:posx,y:posy})
    Util.log.console(todel)
    EM_APP.vizdata.removePosition(todel)
    currentCell = $(todel.posId)
    currentCell.removeClass('stories')
    currentCell.removeClass('forces')
    currentCell.removeClass('solutionComponents')
    currentCell.removeClass('new')
    currentCell.addClass('current')