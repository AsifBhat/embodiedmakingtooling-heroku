jQuery ($) ->
window.exportGraph = (fileName) ->
 exportRequest = $.get "/export/fileName"
 
 exportRequest.success (data) ->
  newwindow = window.open("/assets/exports/clusters.gexf","Exported as GEXF","height=200,width=200")
  
 exportRequest.error (error) ->
  window.consoleLog error
