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
 
getElementInCell = (pos) ->
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


updatePositions = (idToKeep, idsToChange) ->
  console.log "ID to keep and IDs to change"
  console.log(idToKeep, idsToChange)
  $.each(idsToChange, (i, id)->
    $.each(window.posAfterTranslation, (j, pos) ->
      if(pos.clusterid == id)
        pos.clusterid = idToKeep
    )
  )
  console.log("**********")
  console.log(window.posAfterTranslation)
 
clusterToUpdate = {} 
mergeAndAddLink = (link, clusters) ->
  console.log("clusters to merge")
  console.log clusters
  newGraph = []
  clustersToDelete = []
  $.each(clusters, (i, cluster) ->
   if(i>0)
    clustersToDelete.push(cluster.id)
   $.each(cluster.relations, (j,l) ->
     newGraph.push(l)
   )
  ) 
  console.log("********")
  console.log clustersToDelete
  newGraph.push(link)
  clusterToUpdate = {"id":clusters[0].id, "relations":newGraph}
  console.log "To update cluster:"
  console.log(clusterToUpdate)  
  $.ajax
      url: '/api/clusters/'+clusterToUpdate.id,
      type: 'PUT',
      dataType: "json",
      contentType: "application/json",
      data : JSON.stringify(clusterToUpdate),
      success: (updatedCluster, status, response) ->
       console.log("Cluster update request sent:")
       console.log(updatedCluster)
       updatePositions(updatedCluster.id,clustersToDelete)
      error: (jqXHR, textStatus, errorThrown) ->
       console.log errorThrown 
  console.log "To delete clusters:"
  console.log(clustersToDelete)
  $.each(clustersToDelete, (i, ctoDel) ->
    $.ajax
      url: '/api/clusters/'+ctoDel,
      type: 'DELETE',
      contentType: "application/json",
      data : JSON.stringify(ctoDel),
      success: (data, status, response) ->
       console.log("Cluster delete request sent:")
       console.log(data)
      error: (jqXHR, textStatus, errorThrown) ->
       console.log errorThrown   
  )
  
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
       console.log("New cluster creation request sent:")
       console.log(createdCluster)
       window.posAfterTranslation.push({ "coord" : {x:posx, y:posy} , "elem" : datum.id, "clusterid" :createdCluster.id })
      error: (jqXHR, textStatus, errorThrown) ->
       console.log errorThrown     
    else 
     nbClusters = $.unique(nbClusters)    
     link = {"element":datum.id, "relatedElements":nbElements}      
     $.each(nbClusters, (i, nbc) ->
       $.ajax
        url: '/api/clusters/'+nbc,
        type: 'GET',
        contentType: "application/json",
        success: (cluster, status, response) ->
         clustersToMerge.push(cluster)
         if(i==nbClusters.length-1)
           mergeAndAddLink(link, clustersToMerge) 
        error: (jqXHR, textStatus, errorThrown) ->
         console.log errorThrown
         console.log(nbc)    
     ) 
     
     	  	 

#----------------------------------------------------