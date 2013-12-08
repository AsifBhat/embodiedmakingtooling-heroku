// The API developer key obtained from the Google Cloud Console.
// This API key is for the localhost: To be used for local testing 
// REMOVE THIS BEFORE PUBLISHING 
//var developerKey = 'AIzaSyBYEmPSy44XpEXayCK9Xt8_vw_qKLFAkFs';

// TO TEST: EMTool-Staging Key:
var developerKey = 'AIzaSyA1k5GbuawECoBOIQaTFr3PRKB-Gq0RWEM';

AppContext.grid.loadPicker = function() {
  $("body").append('<div id="startupModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"><div class="modal-header"><h3 id="myModalLabel">Select one of the following options</h3></div><div class="modal-footer"><button class="btn" id="create_new_button" data-dismiss="modal" aria-hidden="true">Create a new analysis</button><button class="btn btn-primary" aria-hidden="true" data-dismiss="modal" id="openfile_button">Select from files already saved..</button></div></div>');
  
  $('#create_new_button').click(function(){
    AppContext.grid.initApp();
    startRealtime();
  });

  $('#openfile_button').click(function(){
    gapi.load('picker', {'callback': createPicker});
  });

  $('#startupModal').modal({
    show: true,
    keyboard: false
  });

};
var picker = null;

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

function pickerCallback(data) {
  var url = 'nothing';
  if (data[google.picker.Response.ACTION] == google.picker.Action.PICKED) {
    var doc = data[google.picker.Response.DOCUMENTS][0];
    url = doc[google.picker.Document.URL];
  }
  if(url != 'nothing')
    window.location.replace(url);
  else {
    Util.log.console('Document does not exit any more.');
  }
}

$(document).ready(function(){
  AppContext.grid.loadPicker();
});
