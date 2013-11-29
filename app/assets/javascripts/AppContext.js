var AppContext = function () {} ;

AppContext.grid = {};

AppContext.menu = {};


AppContext.grid.reloadTypeahead = function() {
  Util.log.console ('removing typeahead for resetting it');
  var timeoutID = {};
  try {
	  /*
	  	the timer is a hack for now: need to replace with 'finished 
	  	file upload' event that triggers post file upload
	  */
	  timeoutID = window.setTimeout(AppContext.grid.reload, 5000) 
  }
  catch (error){
  	window.clearTimeout(timeoutID)
  }
}
    
AppContext.grid.reload= function() {
	window.location.reload(true);
}
