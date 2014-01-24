// The API developer key obtained from the Google Cloud Console.
var developerKey = googleAppConf().browserKey;

AppContext.grid.loadApplication = function(){
  AppContext.grid.initApp();
  startRealtime();
}

AppContext.grid.loadPicker = function() {
  try{
    $('body').append('<div id="startupModal" class="modal hide fade app_load_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"><div class="modal-header text-center"><h4 id="myModalLabel">Select one of the following options</h4></div><div class="modal-body"><label>Create a New Making: </label><input type="text" id="proj_name" placeholder="Enter Making Title"></div><div class="modal-footer"><button class="btn btn-primary" aria-hidden="true" data-dismiss="modal" id="create_named_making_btn">Create</button><button class="btn btn btn-warning" aria-hidden="true" data-dismiss="modal" id="openfile_button">Select a file from Google Drive</button><button class="btn load_new_making_btn" data-dismiss="modal" aria-hidden="true">Load Current File</button></div></div>');

    $('#create_named_making_btn').click(function(){
      try {
        handleAuthResult();
        realtimeOptions.defaultTitle = $('#proj_name').val()+'.ema';
        Util.log.console('Going in with file name: ' + realtimeOptions.defaultTitle);
      }
      catch(err){
        console.log(err);
      }
    });
    
    $('.load_new_making_btn').click(function(){
      Util.log.console('File Name not specified. Using default Project name');
      handleAuthResult();
    });

    $('#openfile_button').click(function(){
      //do something to check for authorization
      // this is to make the usr authorize the application before anything can be done
      // else the user will be stuck with a burried pop-up button
      handleAuthResult('old');
    });

    $('#startupModal').modal({
      show: true,
      keyboard: false
    });
  }
  catch(err){
    console.log(err);
  }
}


$(document).ready(function(){
  if(window.location.hash.length == 0 && window.location.search.length == 0)
    AppContext.grid.loadPicker();
  else
    window.onload = AppContext.grid.loadApplication();

  $('.proj_title').keypress(function(e){
    if (e.which === 13){
      e.preventDefault();
      Util.log.console('Title Updated to: ');
      Util.log.console($(this).text());
      Util.log.console('Entery pressed');
      AppContext.project.sendChangeTitleRequest($(this).text())
    }
  });

  $('#import_popover').click(function(evt){
    try {
      $('#import_popover').popover('show');
      $('#import_close').click(function(evt){
        $('#import_popover').popover('hide');
      });
      AppContext.project.bindFileUpload();
    }
    catch (err){
      console.log(err);
    }
  });

  fetchClientDetails(getUserName);

});