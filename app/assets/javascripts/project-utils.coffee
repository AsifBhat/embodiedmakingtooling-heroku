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
          AppContext.project.projectDescription = resp.description
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

AppContext.project.showPicture = (pictureurl) ->
  if pictureurl != null
    # Check if the User has set any Image associated with their profile, then show that
    pictureurl = pictureurl.substr(pictureurl.lastIndexOf('//'), pictureurl.length)
    $('#profile_picture').css("display","").attr("xlink:href",pictureurl)
  else 
    # If no image is associated with the Curren tUser Profile, then show a default Image
    $('#profile_picture').css("display","").attr("xlink:href",'/assets/images/avatar.svg')

AppContext.project.getUserInfo = () ->
  ###
  * Get information about the current user 
  ###
  callback = () ->
  Util.log.console('Fetching User Info..')
  if(gapi.client.drive == undefined)
    gapi.client.load('drive', 'v2', callback );
  try 
    if(gapi.client.drive != undefined)
      request = gapi.client.drive.about.get()
      request.execute( (resp) ->
        try 
          if(resp != undefined)
            $('#authorizeButton').html(resp.name)
            if(resp.user.picture != undefined)
              AppContext.project.showPicture(resp.user.picture.url)
            else 
              AppContext.project.showPicture(null)
        catch err
          Util.log.console 'Error while fetching user information'
          Util.log.console err
      )
    else
      Util.log.console 'Error since the GAPI is not loaded completely'
  catch err
    Util.log.console 'Error Occured while fetching user info'
    Util.log.console err
