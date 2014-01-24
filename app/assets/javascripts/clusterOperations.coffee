getNextPosId = () ->
  return $.newUUID()

AppContext.cluster.updatePosition = (datum,posx,posy) ->
  posid = getNextPosId();
  pos = {x: posx, y:posy}
  existingPosition = AppContext.vizdata.getPositionInCell(pos)
  if(existingPosition  == '')
    position = { posId:posid, x:posx, y:posy, elementId:datum}
    AppContext.vizdata.addPosition(position)
    nbelements = []
    nbcells = AppContext.grid.getAllNeighbourCells(pos)
    $.each(nbcells, (i, nbcell) ->
      targetelem = AppContext.vizdata.getElementInCell(nbcell)      
      if(targetelem!='')
        targetPosition = AppContext.vizdata.getPositionInCell(nbcell)
        rel = {srcElementId: datum, targetElementId: targetelem, srcPosId: posid, targetPosId:targetPosition.posId};
        AppContext.vizdata.addRelation(rel)
    )
  else
    position = { posId:existingPosition.posId, x:posx, y:posy, elementId:datum}
    posIdtoEdit = existingPosition.posId
    AppContext.vizdata.removePosition(existingPosition)
    AppContext.vizdata.addPosition(position)
    relations = AppContext.vizdata.getRelations()
    $.each(relations, (i, relation) ->
      if(relation.srcPosId==posIdtoEdit)
        newRelation = {srcElementId: datum, targetElementId: relation.targetElementId, srcPosId: relation.srcPosId, targetPosId:relation.targetPosId}
        AppContext.vizdata.removeRelation(relation)
        AppContext.vizdata.addRelation(newRelation)
      else if (relation.targetPosId==posIdtoEdit)
        newRelation = {srcElementId: relation.srcElementId, targetElementId: datum, srcPosId: relation.srcPosId, targetPosId:relation.targetPosId}
        AppContext.vizdata.removeRelation(relation)
        AppContext.vizdata.addRelation(newRelation)  
    ) 
    
#----------------------------------------------------
AppContext.cluster.deletePosition = (posx, posy) ->
  todel = AppContext.vizdata.getPositionInCell({x:posx,y:posy})
  AppContext.vizdata.removePosition(todel)
  relations = AppContext.vizdata.getRelations()
  $.each(relations, (i, relation) ->
    if((relation.srcPosId == todel.posId) || (relation.targetPosId == todel.posId))
      AppContext.vizdata.removeRelation(relation)
  )  
  
#---------------------------------------------------------

     
