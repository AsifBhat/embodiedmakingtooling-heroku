getNextPosId = () ->
  allPos = AppContext.vizdata.getPositions()
  nextId = 0
  $.each(allPos, (i, pos) ->
    if(pos.posId >= nextId)
      nextId = pos.posId + 1
  )
  nextId

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
  #AppContext.grid.markBorder(posx, posy);
    # parse through relations array and find all occurences of this posId
    # if srcPosId replace srcElementID with this elementId - delete that relation and add a new relation
    # else if targetPosId replace targetElementId with this elementId
    
#----------------------------------------------------
AppContext.cluster.deletePosition = (posx, posy) ->
  todel = AppContext.vizdata.getPositionInCell({x:posx,y:posy})
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
  
#---------------------------------------------------------

     
