removeetype = false;

handleKeyPress = function(e) {
  if (!e) e = window.event
  var keyCode = e.keyCode || e.which;
  
  Util.log.console(keyCode);
  
  // see if the key entered is a space key or not
  if (keyCode === 32) {
    //get the text in the typeahead input, convert it to lower case and split it by space
    var textContent = getNewElementdesc().toLowerCase().split(' '); 
    var callbackAction = '';
    // Below we get the first key and check if the second key is a space key (' ')
    var etype = getNewElementdesc().substr(0,1).toLowerCase();

    // check if the first element of the array is of a length less then 2 characters
    if(textContent[0].length < 2){
      if(etype == 's'){
        callbackAction =  AppContext.cluster.addStory;
        $('#elementsTab li:eq(0) a').tab('show');

      }  
      else if (etype == 'f'){
        callbackAction = AppContext.cluster.addForce;
        $('#myTab li:eq(1) a').tab('show');
      }
      else if (etype == 'c'){
        callbackAction = AppContext.cluster.addSolution;
        $('#myTab li:eq(2) a').tab('show');
      }
      //if any of the above is possible, then hide the input field 
      // and show a text area to allow a more detailed story
      $('#input-elem-search').fadeOut(2000);
      $('#newElementText').fadeIn(1000);
      $('#newElementText').focus();
      $('#newElementText').keypress(function(e){
        //if enter key is pressed, then remove the textarea and save the corresponding element
        if(e.which === 13){
          var newElementDesc = $('#newElementText').val();
          //clean up input dom and hide the text area and show the input box again
          $('#input-elem-search').val('');
          $('#newElementText').fadeOut(2000);
          $('#newElementText').val('');
          $('#input-elem-search').fadeIn(1000);
          $('#input-elem-search').focus();
          if(callbackAction != ''){
            callbackAction(newElementDesc);
          }
          //save the text that is handed by the textarea
          //finish by removing the textarea
        }
      });


    } else 
      displayOptions();
  }        
}  

displayOptions = function (){
  $('#addFromTypeahead').css("display","");
  var leftpos = $("#content-search").position().left;
  var toppos = $("#content-search").position().top - 30;
  $('#addFromTypeahead').css("left", leftpos + "px");
  $('#addFromTypeahead').css("top", toppos + "px");
}

getNextElemId = function(allElem) {
  var nextId = 1;
  $(allElem).each(function(i){
    var id = this.elementId;
    var numstr = id.substr(1,id.length);
    var num = parseInt(numstr,10);
    if(num>=nextId){
      nextId = num+1;
    }
  });
  Util.log.console("Returned elemID:"+nextId);
  return nextId;
};

getNextStoryId =  function() {
  return getNextElemId(AppContext.vizdata.getStories());
};

getNextForceId =  function() {
  Util.log.console('Number of forces: ');
  Util.log.console(AppContext.vizdata.getForces());
  return getNextElemId(AppContext.vizdata.getForces());
};

getNextSolutionId =  function() {
  return getNextElemId(AppContext.vizdata.getSolutions());
};


getNewElementdesc = function(){
  var textdesc = $('#input-elem-search').val();
  if(removeetype){
	  textdesc = textdesc.substr(2,textdesc.length-2);
	  removeetype = false;
  }
  return textdesc;  
};

AppContext.cluster.addStory = function(desc) {
  //var desc = getNewElementdesc();
  var idstr = "S"+getNextStoryId();
  var elemObj = {"elementId": idstr, "description":desc};
  AppContext.vizdata.addElement(elemObj);
  Util.log.console(elemObj);
  var datum = {"value":idstr};
  AppContext.grid.addGridPos(null,datum,'story');
  $('#addFromTypeahead').css("display","none");
};

AppContext.cluster.addForce = function(desc) {
  //var desc = getNewElementdesc();
  var idstr = "F"+getNextForceId();
  var elemObj = {"elementId": idstr, "description":desc};
  AppContext.vizdata.addElement(elemObj);
  var datum = {"value":idstr};
  AppContext.grid.addGridPos(null,datum,'force');
  $('#addFromTypeahead').css("display","none");
};


AppContext.cluster.addSolution = function(desc) {
  //var desc = getNewElementdesc();
  var idstr = "C"+getNextSolutionId();
  var elemObj = {"elementId": idstr, "description":desc};
  AppContext.vizdata.addElement(elemObj);
  Util.log.console(elemObj);
  var datum = {"value":idstr};
  AppContext.grid.addGridPos(null,datum,'solution');
  $('#addFromTypeahead').css("display","none");
};

getElement = function(id){
  var allElems = AppContext.vizdata.getElements();
  var elem = '';
  $.each(allElems, function(i) {
    if (this.elementId == id)
      elem= this;
  });
  return elem;
}

/* 
  Deletes all occurrances of a given element with the given element-ID
  And also remove the element from the realtime data
*/
AppContext.cluster.deleteElem = function(idToDel){
  /*var idtodel = $(domelem).data('elementid');*/
  Util.log.console("To delete elem:"+idToDel);
  var elemtodel = getElement(idToDel);
  
  // get all positions
  // remove any pos that has elemtodel in src or target
  // get all relations
  // 
  var allpositions = AppContext.vizdata.getPositions();
  $.each(allpositions, function(i, pos) {
    if(pos.elementId == idToDel) {
      Util.log.console("Must del pos:"+pos.posId);
      AppContext.vizdata.removePosition(pos);
      var relations = AppContext.vizdata.getRelations();
      $.each(relations, function(i, relation) {
        if ((relation.srcPosId === pos.posId) || (relation.targetPosId === pos.posId)) {
          AppContext.vizdata.removeRelation(relation);
        }
      });
      domElemToDel = $(pos.posId);
      domElemToDel.removeClass('stories');
      domElemToDel.removeClass('forces');
      domElemToDel.removeClass('solutionComponents');
      domElemToDel.removeClass('new');
    }
      
  });
  AppContext.vizdata.removeElement(elemtodel);
};
  
AppContext.cluster.updateElem = function(idToEdit, newDesc)  {
  idToEdit = idToEdit.trim();
  var newElem = {"elementId":idToEdit,"description":newDesc};
  Util.log.console("new element:");
  Util.log.console(newElem);
  var elemtodel = getElement(idToEdit);
  AppContext.vizdata.removeElement(elemtodel);
  AppContext.vizdata.addElement(newElem);
};
