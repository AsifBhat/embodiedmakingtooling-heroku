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
 $.each(window.posAfterTranslation, (i,position) ->
  if (position.coord.x == pos.x) && (position.coord.y == pos.y)  
    empty = false
 )	
 empty	
 
window.getElementInCell = (pos) ->
 elem = ''
 $.each(window.posAfterTranslation, (i,position) ->
  if (position.coord.x == pos.x) && (position.coord.y == pos.y)  
    elem = position.elem  
 )	 
 elem
 
getClusterInCell = (pos) ->
 cluster = ''
 $.each(window.posAfterTranslation, (i,position) ->
  if (position.coord.x == pos.x) && (position.coord.y == pos.y)  
    cluster = position.clusterid  
 )	 
 cluster

 #-------------------------------------------------------------------------------------- 

updatePositions = (idToKeep, idsToChange) ->
  window.consoleLog "ID to keep and IDs to change"
  window.consoleLog(idToKeep, idsToChange)
  $.each(idsToChange, (i, id)->
    $.each(window.posAfterTranslation, (j, pos) ->
      if ((pos.clusterid == id) || (pos.clusterid == "temp"))
        pos.clusterid = idToKeep
    )
  )
  window.consoleLog("window.posAfterTranslation: ")
  window.consoleLog(window.posAfterTranslation)
 
clusterToUpdate = {} 
  
#--------------------------------------------------------------------------------------  
mergeAndAddLink = (link, clusters, posUpdate) ->
  window.consoleLog("clusters to merge")
  window.consoleLog clusters
  newGraph = []
  clustersToDelete = []
  window.consoleLog(clusters)	
  $.each(clusters, (i, cluster) ->
   $.each(cluster.relations, (j,l) ->
     newGraph.push(l)
   )
  ) 
   
  # (if cluster.id != clusters[0].id then (clustersToDelete.push cluster.id)) for cluster in clusters
  idToKeep = clusters.splice(0,1)
  window.consoleLog("Clusters to delete:")
  window.consoleLog clusters
  newGraph.push(link)
  clusterToUpdate = {"id":idToKeep[0].id, "relations":newGraph}
  posUpdate.clusterid = idToKeep[0].id
  window.posAfterTranslation.push(posUpdate)
  window.consoleLog "To update cluster:"
  window.consoleLog(clusterToUpdate)  
  $.ajax
      url: '/api/clusters/'+clusterToUpdate.id,
      type: 'PUT',
      dataType: "json",
      contentType: "application/json",
      data : JSON.stringify(clusterToUpdate),
      success: (updatedClusterId, status, response) ->
       window.consoleLog("Cluster update request sent:")
       window.consoleLog(updatedClusterId)
       updatePositions(updatedClusterId,clusters)
      error: (jqXHR, textStatus, errorThrown) ->
       window.consoleLog errorThrown 
  window.consoleLog "To delete clusters:"
  window.consoleLog(clusters)
  $.each(clusters, (i, ctoDel) ->
    $.ajax
      url: '/api/clusters/'+ctoDel.id,
      type: 'DELETE',
      success: (data, status, response) ->
       window.consoleLog("Cluster delete request sent:")
       window.consoleLog(data)
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
    if loneCell 
     newclusterdata =  {"id":"newid","relations":[{"element":datum.id,"relatedElements":[]}]}
     $.ajax
      url: '/api/clusters',
      type: 'POST',
      dataType: "json",
      contentType: "application/json",
      data : JSON.stringify(newclusterdata),
      success: (createdCluster, status, response) ->
       window.consoleLog("New cluster creation request sent:")
       window.consoleLog(createdCluster)
       window.posAfterTranslation.push({ "coord" : {x:posx, y:posy} , "elem" : datum.id, "clusterid" :createdCluster.id })
      error: (jqXHR, textStatus, errorThrown) ->
       window.consoleLog errorThrown     
    else 
     nbClusters = $.unique(nbClusters)    
     window.consoleLog("nbClusters: ")
     window.consoleLog(nbClusters)
     link = {"element":datum.id, "relatedElements":nbElements}     
     $.each(nbClusters, (i, nbc) ->
       if(nbc!="temp")
        $.ajax
         url: '/api/clusters/'+nbc,
         type: 'GET',
         async: false,
         contentType: "application/json",
         success: (cluster, status, response) ->
          clustersToMerge.push(cluster)
          console.log("Pushed to clustersToMerge: "+nbc)
          if (i == nbClusters.length-1)  
        	  posUpdate = { "coord" : {x:posx, y:posy} , "elem" : datum.id, "clusterid" :"temp" }
        	  mergeAndAddLink(link, clustersToMerge, posUpdate)
         error: (jqXHR, textStatus, errorThrown) ->
           window.consoleLog errorThrown
           window.consoleLog(nbc)    
     ) 
     
     	  	 

#----------------------------------------------------