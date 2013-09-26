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
 
clusterToUpdate = {} 
addLinkToCluster = (link, clusters) ->
  newGraph = []
  clusterToDelete = []
  $.each(clusters, (i, cluster) ->
   if(i>0)
    clusterToDelete.push(cluster.clusterId)
   $.each(cluster.graph, (j,l) ->
     newGraph.push(l)
   )
  ) 
  newGraph.push(link)
  clusterToUpdate = {"id":clusters[0].clusterId, "relations":newGraph}
  console.log(clusterToUpdate)  
  console.log(clusterToDelete)

createCallBack = (data, textStatus, jqXHR)  ->
  console.log(textStatus)

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
    if loneCell 
     newclusterdata =  {"id":"newid","relations":[{"element":datum.id,"relatedElements":["F0001","F0002"]}]}
     $.ajax
      url: '/api/clusters',
      type: 'POST',
      dataType: "json",
      contentType: "application/json",
      data : JSON.stringify(newclusterdata),
      success: (data, status, response) ->
       console.log("New cluster creation request sent:")
       console.log(data)
      error: (jqXHR, textStatus, errorThrown) ->
       alert errorThrown     
     window.posAfterTranslation.push({ "coord" : {x:posx, y:posy} , "elem" : datum.id, "clusterid" :"newclusterid" })
    else 
     nbClusters = $.unique(nbClusters)
     console.log("Modify cluster") 
     console.log(nbElements)
     console.log(nbClusters)
     link = {"element":datum.id, "relatedElements":nbElements}
     clustersToMerge = []
     $.each(nbClusters, (i, nbc) ->
       clusterRequest = $.getJSON "/api/cluster/"+nbc
       clusterRequest.success (data) ->
      	 clustersToMerge.push(data)
     ) 	  	 
     addLinkToCluster(link, clustersToMerge)

#----------------------------------------------------