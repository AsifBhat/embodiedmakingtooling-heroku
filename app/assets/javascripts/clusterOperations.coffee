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
 
isEmpty = (pos) ->
 empty = true
 $.each(window.posOnGrid, (i,position) ->
  if (position.xPos == pos.x) && (position.yPos == pos.y)  
    empty = false
 )	
 empty	
 
window.getElementInCell = (pos) ->
 elem = ''
 $.each(window.posOnGrid, (i,position) ->
  if (position.xPos == pos.x) && (position.yPos == pos.y)  
    elem = position.elementId
 )	 
 elem
 
getClusterInCell = (pos) ->
 cluster = ''
 $.each(window.posOnGrid, (i,position) ->
  if (position.xPos == pos.x) && (position.yPos == pos.y)  
    cluster = position.clusterId  
 )	 
 cluster

 #-------------------------------------------------------------------------------------- 

updatePositions = (idToKeep, idsToChange) ->
  $.each(idsToChange, (i, id)->
    $.each(window.posOnGrid, (j, pos) ->
      if ((pos.clusterId == id) || (pos.clusterId == "temp"))
        pos.clusterId = idToKeep
    )
  )

clusterToUpdate = {} 
  
#--------------------------------------------------------------------------------------  
mergeAndAddLink = (link, clusters, posUpdate) ->
  newGraph = []
  clustersToDelete = []
  $.each(clusters, (i, cluster) ->
   $.each(cluster.relations, (j,l) ->
     newGraph.push(l)
   )
  ) 
   
  # (if cluster.id != clusters[0].id then (clustersToDelete.push cluster.id)) for cluster in clusters
  idToKeep = clusters.splice(0,1)
  newGraph.push(link)
  clusterToUpdate = {"id":idToKeep[0].id, "relations":newGraph}
  posUpdate.clusterId = idToKeep[0].id
  $.ajax
      url: '/api/clusters/'+clusterToUpdate.id,
      type: 'PUT',
      dataType: "json",
      contentType: "application/json",
      data : JSON.stringify(clusterToUpdate),
      success: (updatedClusterId, status, response) ->
       updatePositions(updatedClusterId,clusters)
      error: (jqXHR, textStatus, errorThrown) ->
       window.consoleLog errorThrown 
  $.each(clusters, (i, ctoDel) ->
    $.ajax
      url: '/api/clusters/'+ctoDel.id,
      type: 'DELETE',
      success: (data, status, response) ->
       window.consoleLog(data)
      error: (jqXHR, textStatus, errorThrown) ->
       window.consoleLog errorThrown   
  )  
  # Update positions on server
  # Update positions - when there is no merge, there is only a call to create a pos entry
  $.ajax
      url: '/api/positions',
      type: 'POST',
      dataType: "json",
      async: false,
      contentType: "application/json",
      data : JSON.stringify(posUpdate),
      success: (createdPos, status, response) ->
       window.posOnGrid.push(createdPos)
      error: (jqXHR, textStatus, errorThrown) ->
       window.consoleLog errorThrown         
  # Update positions - when there is a merge, there is 
  # 1) a call to create a pos entry (above)
  # 2) an update call - PUT - with the cluster id to be replaced. The payload will be the id to keep.
  #    The expected response should be the list of altered positions.[TODO]
  $.each(clusters, (i, ctoDel) ->
    $.ajax
      url: '/api/positions/'+ctoDel.id,
      type: 'PUT',
      dataType: "json",
      data: JSON.stringify(idToKeep[0].id),
      contentType: "application/json",
      success: (listOfUpdatedPos, status, response) ->
       window.consoleLog(listOfUpdatedPos) # [TODO]
      error: (jqXHR, textStatus, errorThrown) ->
       window.consoleLog errorThrown   
  )  
 #-------------------------------------------------------------------------------------- 
  
window.updateClusters = (obj, datum, dataset,posx,posy) ->
    pos = { x:posx , y:posy }
    nbs = getAllNeighbourCells(pos)
    loneCell = true
    nbElements = []
    nbClusters = []
    $.each(nbs, (i, value) ->
      if (isEmpty(value)==false)
       loneCell = false
       nbElements.push(getElementInCell(value))
       nbClusters.push(getClusterInCell(value))
    )
    clustersToMerge = []
    posDataToSend = ''
    if loneCell 
     newclusterdata =  {"id":"newid","relations":[{"element":datum.id,"relatedElements":[]}]}
     $.ajax
      url: '/api/clusters',
      type: 'POST',
      dataType: "json",
      contentType: "application/json",
      async: false,
      data : JSON.stringify(newclusterdata),
      success: (createdCluster, status, response) ->
       posDataToSend = {posId:"temp", elementId: datum.id, clusterId:createdCluster.id, xPos:posx, yPos:posy}
      error: (jqXHR, textStatus, errorThrown) ->
       window.consoleLog errorThrown  
     $.ajax
      url: '/api/positions',
      type: 'POST',
      dataType: "json",
      async: false,
      contentType: "application/json",
      data : JSON.stringify(posDataToSend),
      success: (createdPos, status, response) ->
       window.posOnGrid.push(createdPos)
      error: (jqXHR, textStatus, errorThrown) ->
       window.consoleLog errorThrown           
    else 
     nbClusters = $.unique(nbClusters)    
     link = {"element":datum.id, "relatedElements":nbElements}
     $.each(nbClusters, (i, nbc) ->
        $.ajax
         url: '/api/clusters/'+nbc,
         type: 'GET',
         async: false,
         contentType: "application/json",
         success: (cluster, status, response) ->
          clustersToMerge.push(cluster)
         error: (jqXHR, textStatus, errorThrown) ->
           window.consoleLog errorThrown
     )
     posUpdate = {posId: "temp", elementId: datum.id, clusterId:"temp", xPos:posx, yPos:posy }
     mergeAndAddLink(link, clustersToMerge, posUpdate)

#----------------------------------------------------