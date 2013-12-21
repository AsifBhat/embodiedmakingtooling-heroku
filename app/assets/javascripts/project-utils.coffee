AppContext.project.getFileDetails = () ->
  try 
    if(rtclient.params != undefined)
      fileId = rtclient.params['fileIds']
      if(window.location.search.length != 0 )
        fileId = rtclient.params['ids']
      if(fileId != undefined)
        AppContext.project.fileId = fileId
        rtclient.getFileMetadata(fileId, (resp) ->
          AppContext.project.projectTitle = resp.title
          AppContext.vizdata.projectDescription = resp.description
          AppContext.project.updateTitleText()
          Util.log.console 'Fetched file details'
        )
  catch err 
    Util.log.console err
    
AppContext.project.editProjectTitle = () ->
  modalHTML = '<div id="edit_title_modal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"><div class="modal-header"><button type="button" class="close close_title_modal" data-dismiss="modal" aria-hidden="true">&times;</button><h5 id="myModalLabel">Rename the Current Project</h5></div><div class="modal-body"><label>Enter the name of Project: </label><input type="text" id="proj_name" placeholder="Enter Project Name"></div><div class="modal-footer"><button class="btn btn-warning close_title_modal" data-dismiss="modal" aria-hidden="true">Retain Current Name</button><button class="btn btn-success" aria-hidden="true" data-dismiss="modal" id="change_title">Change ProjectTitle</button></div></div>'
  
  $('body').append(modalHTML)

  $('#change_title').click( ()->
    title = $('#proj_name').val()
    $('.proj_title').text(title)
    AppContext.project.sendChangeTitleRequest(title)
  )

  $('#edit_title_modal').modal({
    show: true,
    keyboard: true
  })

AppContext.project.updateTitleText = () ->
  $('.proj_title').text(AppContext.project.projectTitle.split('\.')[0])
  $('.proj_title').mouseover( () ->
    handleTooltip = () ->
      $('.proj_title').popover('show')
      $('#edit_project_name').click( () ->
        AppContext.project.editProjectTitle()
        $('.proj_title').popover('hide')
      )

      $('#cl_edit_project_name').click( () ->
        $('.proj_title').popover('hide')
      )
      
      popoverDOM = $('.title_holder').find('.popover')
      popoverTop = popoverDOM.css('top').slice(0, popoverDOM.css('top').indexOf('p'))
      popoverLeft = popoverDOM.css('left').slice(0, popoverDOM.css('top').indexOf('p'))
      #popoverDOM.css('top', (parseInt(popoverTop, 10)+30)+'px')
      popoverDOM.css('left', (parseInt(popoverLeft, 10)/2)+'px')

      #popoverDOM.find('.arrow').css('top', '25%')

    handleTooltip()
  )

  $('#edit_project_name').click( () ->
    AppContext.project.editProjectTitle()
    $('.proj_title').popover('hide')
  )

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
    AppContext.project.updateTitleText()
    AppContext.vizdata.updateTitle(newTitle)
    Util.log.console 'Project Title Changed'
  )