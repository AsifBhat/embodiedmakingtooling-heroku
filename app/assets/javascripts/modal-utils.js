// The API developer key obtained from the Google Cloud Console.
// This API key is for the localhost: To be used for local testing 
// REMOVE THIS BEFORE PUBLISHING 
var developerKey = 'AIzaSyBYEmPSy44XpEXayCK9Xt8_vw_qKLFAkFs';

//Heroku App Key
//var developerKey = 'AIzaSyD7MkLjTksTUuovzbvMfXHMrYMh7EnYAz4';

AppContext.grid.loadApplication = function(){
  AppContext.grid.initApp();
  startRealtime();
}

AppContext.grid.loadPicker = function() {
  try{
    $('body').append('<div id="startupModal" class="modal hide fade app_load_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"><div class="modal-header text-center"><h4 id="myModalLabel">Select one of the following options</h4></div><div class="modal-body"><label>Create a New Making: </label><input type="text" id="proj_name" placeholder="Enter Making Title"></div><div class="modal-footer"><button class="btn btn-primary" aria-hidden="true" data-dismiss="modal" id="create_named_making_btn">Create</button><button class="btn btn btn-warning" aria-hidden="true" data-dismiss="modal" id="openfile_button">Select a file from Google Drive</button><button class="btn load_new_making_btn" data-dismiss="modal" aria-hidden="true">Load Current File</button></div></div>');

    $('#create_named_making_btn').click(function(){
      try {
        realtimeOptions.defaultTitle = $('#proj_name').val()+'.ema';
        Util.log.console('Going in with file name: ' + realtimeOptions.defaultTitle);
        AppContext.grid.loadApplication();
        //$('#project_name').text(realtimeOptions.defaultTitle);
      }
      catch(err){
        console.log(err);
      }
    });

    $('.load_new_making_btn').click(function(){
      Util.log.console('File Name not specified. Using default Project name');
      AppContext.grid.loadApplication();
    });

    $('#openfile_button').click(function(){
      //do something to check for authorization
      // this is to make the usr authorize the application before anything can be done
      // else the user will be stuck with a burried pop-up button
      gapi.load('picker', {'callback': createPicker});
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

var picker = null;
  // Create and render a Picker object for searching images.
function createPicker() {
    picker = new google.picker.PickerBuilder().
        addView(new google.picker.View(google.picker.ViewId.DOCS).
          setQuery('.ema')).
        enableFeature(google.picker.Feature.NAV_HIDDEN).
        setDeveloperKey(developerKey).
        setCallback(pickerCallback).
        build();
    picker.setVisible(true);
  }

  // A simple callback implementation.
  function pickerCallback(data) {
    console.log('Calling picker callback');
    var url = 'nothing';
    if (data[google.picker.Response.ACTION] == google.picker.Action.PICKED) {
      var doc = data[google.picker.Response.DOCUMENTS][0];
      url = doc[google.picker.Document.URL];
    }
    if(url != 'nothing')
      window.location.replace(url);
  }

$(document).ready(function(){
  if(window.location.hash.length == 0 && window.location.search.length == 0)
    AppContext.grid.loadPicker();
  else
    window.onload = AppContext.grid.loadApplication();

  fetchClientDetails(getUserName);
  
  $('.proj_title').keypress(function(e){
    if (e.which === 13){
      e.preventDefault();
      Util.log.console('Title Updated to: ');
      Util.log.console($(this).text());
      Util.log.console('Entery pressed');
      AppContext.project.sendChangeTitleRequest($(this).text())
    }
  });

});