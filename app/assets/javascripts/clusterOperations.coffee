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
  Util.log.console("Existing position")
  Util.log.console(existingPosition)
  if(existingPosition  == '')
    position = { posId:posid, x:posx, y:posy, elementId:datum}
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
        Util.log.console("Edited relation: srcposid")
        Util.log.console(newRelation)        
      else if (relation.targetPosId==posIdtoEdit)
        newRelation = {srcElementId: relation.srcElementId, targetElementId: datum, srcPosId: relation.srcPosId, targetPosId:relation.targetPosId}
        AppContext.vizdata.removeRelation(relation)
        AppContext.vizdata.addRelation(newRelation)  
        Util.log.console("Edited relation: targetposid")
        Util.log.console(newRelation)
    ) 
  AppContext.cluster.markBorder(posx, posy);
    # parse through relations array and find all occurences of this posId
    # if srcPosId replace srcElementID with this elementId - delete that relation and add a new relation
    # else if targetPosId replace targetElementId with this elementId
    
#----------------------------------------------------
AppContext.cluster.deletePosition = (posx, posy) ->
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
  
#---------------------------------------------------------
AppContext.cluster.hasOneEmptyNeighbour = (pos) ->
  emptynbs = false
  # If at least one of the neighbours of this cell is empty, the borders need to be marked
  allnbcells = AppContext.grid.getAllNeighbourCells(pos)
  $.each(allnbcells, (i, nbcell) ->
    nbposition = AppContext.vizdata.getPositionInCell(nbcell)
    if(AppContext.vizdata.isEmpty(nbposition))
      emptynbs = true
  )
  emptynbs
  

isTopEmpty = (posx, posy) ->
  AppContext.vizdata.isEmpty({x:posx, y:posy+1})
###  if posy<0
    AppContext.vizdata.isEmpty({x:posx, y:posy+1})
  else
    AppContext.vizdata.isEmpty({x:posx, y:posy-1})###


#polygon(27% 0%, 72% 0%, 100% 50%, 72% 100%, 27% 100%, 0% 50%)

getBorderString = ( posx, posy) ->
  borders = []
  if(AppContext.vizdata.isEmpty({x:posx, y:posy+1}))
    Util.log.console("top")
    borders.push("27% 0%")
    borders.push("72% 0%") # show top border
  else  
    borders.push("27% 10%")
    borders.push("72% 10%") # hide top border
  
  if(AppContext.vizdata.isEmpty({x:posx+1, y:posy})) # show top right border
    Util.log.console("top right")
    borders.push("72% 0%") # start top right border
    borders.push("95% 45%") 
    borders.push("95% 50%") # stop top right border
  else # hide top right border
    borders.push("72% 10%")
    borders.push("90% 42%") 
    borders.push("90% 53%") 

  if(AppContext.vizdata.isEmpty({x:posx+1, y:posy-1}))
    Util.log.console("bottom right") 
    borders.push("95% 50%") # start bottom right border
    borders.push("72% 100%")
  else
    borders.push("90% 48%")
    borders.push("90% 52%")
    borders.push("68% 90%")  

  if(AppContext.vizdata.isEmpty({x:posx, y:posy-1}))
    Util.log.console("bottom")
    borders.push("72% 100%")
    borders.push("30% 100%")
  else
    borders.push("72% 90%")
    borders.push("32% 90%")  

  if(AppContext.vizdata.isEmpty({x:posx-1, y:posy}))
    Util.log.console("bottom left") 
    borders.push("30% 100%")  
    borders.push("3% 53%")
    borders.push("3% 50%")
  else
    borders.push("32% 90%")
    borders.push("10% 54%")
    
  if(AppContext.vizdata.isEmpty({x:posx-1, y:posy+1}))
    Util.log.console("top left")
    borders.push("0% 53%")
    borders.push("27% 0%")
  else
    borders.push("10% 45%")  
    borders.push("32% 10%")

  borders.join()

#---------------------------------------------------------
# Should ideally update the extents of a cluster, surrounding the given posx and posy
# Now, all borders are being updated
AppContext.cluster.markBorder = (posx, posy) ->
  allpositions = AppContext.vizdata.getPositions()
  $.each(allpositions, (i, position) ->
    domElem = $('#'+position.posId)
    pos = {x:position.x, y:position.y}
    emptynbs = AppContext.cluster.hasOneEmptyNeighbour(pos)
    if(emptynbs)
      $(domElem).addClass("bordered")
    clip = getBorderString( pos.x, pos.y)  
    $(domElem).css("-webkit-clip-path","polygon("+clip+")")
  )  
     