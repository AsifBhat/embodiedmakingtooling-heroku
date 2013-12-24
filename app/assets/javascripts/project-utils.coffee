AppContext.project.getFileDetails = () ->
  try 
    if(rtclient.params != undefined)
      fileId = rtclient.params['fileIds']
      if(window.location.search.length != 0 )
        fileId = rtclient.params['ids']
      if(fileId != undefined)
        AppContext.project.fileId = fileId
        rtclient.getFileMetadata(fileId, (resp) ->
          # Need to remove the AppContext.project.projectTitle as the information is already stored 
          AppContext.project.projectTitle = resp.title 
          AppContext.vizdata.projectDescription = resp.description
          AppContext.project.updateTitleText()
          Util.log.console 'Fetched file details'
        )
  catch err 
    Util.log.console err
    
# Update the title of the Making. To be called only by Google RealTime API
AppContext.project.updateTitleText = () ->
  $('.proj_title').text(AppContext.project.projectTitle.split('\.')[0])

###
  Send a request to the Google Drive API to change 
  the title of the file associated with the making.
  If the title change is a success, then update the 
  associated viz data in the RealTime datastructure.
###
AppContext.project.sendChangeTitleRequest = (newTitle) ->
  newTitle = newTitle + '.ema'
  fileId = AppContext.project.fileId
  body = {'title': newTitle}
  request = gapi.client.drive.files.patch({
    'fileId': fileId,
    'resource': body
  })
  request.execute( (resp) ->
    AppContext.project.projectTitle = newTitle
    AppContext.vizdata.updateTitle(newTitle)
    Util.log.console 'Project Title Changed'
  )

AppContext.project.getUserInfo = () ->
  ###
  * Get information about the current user 
  ###
  Util.log.console('Fetching User Info..')
  try 
    request = gapi.client.drive.about.get()
    request.execute( (resp) ->
      try 
        $('#authorizeButton').html(resp.name)
        console.log('Current user name: ' + resp.name)
        ###
          console.log('Root folder ID: ' + resp.rootFolderId)
          console.log('Total quota (bytes): ' + resp.quotaBytesTotal)
          console.log('Used quota (bytes): ' + resp.quotaBytesUsed)
        ###
      catch err
        console.log 'Error while fetching user information'
        console.log err
    )
  catch err
    console.log 'Error Occured while fetching user info'
    console.log err
