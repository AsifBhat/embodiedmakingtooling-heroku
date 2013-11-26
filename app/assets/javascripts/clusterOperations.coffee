posid=0
elemid=0

AppContext.grid.updatePosition = (obj, datum, dataset,posx,posy) ->
  pos = {x: posx, y:posy}
  existingPosition = AppContext.vizdata.getPositionInCell(pos)
  Util.log.console("Existing position")
  Util.log.console(existingPosition)
  if(existingPosition  == '')
    position = { posId:posid, x:posx, y:posy, elementId:datum, description : " x: "+posx+", y: "+posy }
    AppContext.vizdata.addPosition(position)
    Util.log.console("Added position")
    Util.log.console(position)
    nbelements = []
    nbcells = AppContext.grid.getAllNeighbourCells(pos)
    $.each(nbcells, (i, nbcell) ->
      targetelem = AppContext.vizdata.getElementInCell(nbcell)      
      if(targetelem!='')
        targetPosition = AppContext.vizdata.getPositionInCell(nbcell)
        rel = {srcElementId: datum, targetElementId: targetelem, srcPosId: posid, targetPosId:targetPosition.posId};
        AppContext.vizdata.addRelation(rel)
        Util.log.console("Added relation")
        Util.log.console(rel)
    )
    posid = posid + 1
  else
    position = { posId:existingPosition.posId, x:posx, y:posy, elementId:datum, description : " x: "+posx+", y: "+posy }
    posIdtoEdit = existingPosition.posId
    AppContext.vizdata.removePosition(existingPosition)
    AppContext.vizdata.addPosition(position)
    relations = AppContext.vizdata.getRelations()
    $.each(relations, (i, relation) ->
      if(relation.srcPosId==posIdtoEdit)
        newRelation = {srcElementId: datum, targetElementId: relation.targetElementId, srcPosId: relation.srcPosId, targetPosId:relation.targetPosId}
        AppContext.vizdata.removeRelation(relation)
        AppContext.vizdata.addRelation(newRelation)
        Util.log.console("Edited relation: srcposid")
        Util.log.console(newRelation)        
      else if (relation.targetPosId==posIdtoEdit)
        newRelation = {srcElementId: relation.srcPosId, targetElementId: datum, srcPosId: relation.srcPosId, targetPosId:relation.targetPosId}
        AppContext.vizdata.removeRelation(relation)
        AppContext.vizdata.addRelation(newRelation)  
        Util.log.console("Edited relation: targetposid")
        Util.log.console(newRelation)
    )
    # parse through relations array and find all occurences of this posId
    # if srcPosId replace srcElementID with this elementId - delete that relation and add a new relation
    # else if targetPosId replace targetElementId with this elementId
    
#----------------------------------------------------
AppContext.grid.deletePosition = (posx, posy) ->
  Util.log.console("To delete"+posx+","+posy)
  todel = AppContext.vizdata.getPositionInCell({x:posx,y:posy})
  Util.log.console(todel)
  AppContext.vizdata.removePosition(todel)
  relations = AppContext.vizdata.getRelations()
  domElemToDel = $(todel.posId)
  $.each(relations, (i, relation) ->
    if((relation.srcPosId == todel.posId) || (relation.targetPosId == todel.posId))
      AppContext.vizdata.removeRelation(relation)
  )  
  domElemToDel.removeClass('stories')
  domElemToDel.removeClass('forces')
  domElemToDel.removeClass('solutionComponents')
  domElemToDel.removeClass('new')
  domElemToDel.addClass('current')
  