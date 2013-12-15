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
    $('body').append('<div id="startupModal" class="modal hide fade app_load_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"><div class="modal-header text-center"><h4 id="myModalLabel">Select one of the following options</h4></div><div class="modal-footer"><!--button class="btn btn-warning" id="load_prj_button" data-dismiss="modal" aria-hidden="true">Load Previous Work</button--><button class="btn btn-success" id="create_new_button" data-dismiss="modal" aria-hidden="true">Create a new analysis</button><button class="btn btn btn-warning" aria-hidden="true" data-dismiss="modal" id="openfile_button">Select from files already saved..</button></div></div>');

    /*$('#load_prj_button').click(function(){
      AppContext.grid.loadApplication();
    });*/

    $('#create_new_button').click(function(){
      //AppContext.grid.initApp();
      createModal('modalID', 'optn1ID', 'optn2ID');
      //startRealtime();
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

var createModal = function(modalWindowID, button1, button2_id){
  try{
    var modalHTML = '<div id="'+modalWindowID+'" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"><div class="modal-header"><button type="button" class="close '+button1+'" data-dismiss="modal" aria-hidden="true">&times;</button><h5 id="myModalLabel">Name the file you wish to create</h5></div><div class="modal-body"><label>Enter the name of Project: </label><input type="text" id="proj_name" placeholder="Enter Project Name"></div><div class="modal-footer"><button class="btn '+button1+'" data-dismiss="modal" aria-hidden="true">Load Current File</button><button class="btn btn-primary" aria-hidden="true" data-dismiss="modal" id="'+button2_id+'">Create</button></div></div>';

    $('body').append(modalHTML);

    $('.'+button1).click(function(){
      console.log('File Name not specified. Using default Project name');
      AppContext.grid.loadApplication();
    });

    $('#'+button2_id+'').click(function(){
      try {
        realtimeOptions.defaultTitle = $('#proj_name').val()+'.ema';
        console.log('Going in with file name: ' + realtimeOptions.defaultTitle);
        AppContext.grid.loadApplication();
        //$('#project_name').text(realtimeOptions.defaultTitle);
      }
      catch(err){
        console.log(err);
      }
    });

    $('#'+modalWindowID+'').modal({
      show: true,
      keyboard: true
    });
  }
  catch(err){
    console.log(err);
  }
};

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
  $('.proj_title').attr('data-content', '<div class="title_edit"><button id="edit_project_name" class="btn btn-mini"> Edit Project Title <span class="icon-edit"></span></button><button id="cl_edit_project_name" class="btn btn-mini"> Cancel <span class="icon-edit"></span></button></div>');
});