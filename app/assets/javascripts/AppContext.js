var AppContext = function () {} ;

AppContext.grid = {};

AppContext.menu = {};

AppContext.project = {};

AppContext.graph = {};

AppContext.grid.reloadTypeahead = function() {
  Util.log.console ('Reloading the page to recreate typeahead');
  var timeoutID = {};
  try {
	  /*
	  	the timer is a hack for now: need to replace with 'finished 
	  	file upload' event that triggers post file upload
	  */
	  timeoutID = window.setTimeout(AppContext.grid.reload, 5000);
    startMessage = 'Uploading File...';

    AppContext.grid.fadeItem($('#message'), 2000, AppContext.grid.showMessageBoard, startMessage);
    
    AppContext.grid.fadeItem($('#progress_container'), 4000, AppContext.grid.showProgressBar, 1.5);

    messageString = 'Finished File upload <br> The page will reload now..';

    AppContext.grid.fadeItem($('#message'), 4000, AppContext.grid.showMessageBoard, messageString);
  }
  catch (error){
    Util.log.console (error);
  	window.clearTimeout(timeoutID);
  }
}
    
AppContext.grid.reload= function() {
	window.location.reload(true);
}
