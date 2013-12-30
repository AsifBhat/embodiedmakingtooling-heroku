removeetype = false;

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
  Util.log.console('Next Element Id ' + nextId);
  return nextId;
};

getNextStoryId =  function() {
  return getNextElemId(AppContext.vizdata.getStories());
};

getNextForceId =  function() {
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

AppContext.cluster.addNewElement = function(elemId, desc, type) {
  var elemObj = {"elementId": elemId, "description":desc};
  AppContext.vizdata.addElement(elemObj);
  var datum = {"value":elemId};
  AppContext.grid.addGridPos(null,datum,type);
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
  var elemtodel = getElement(idToDel);
  
  // get all positions
  // remove any pos that has elemtodel in src or target
  // get all relations
  // 
  var allpositions = AppContext.vizdata.getPositions();
  $.each(allpositions, function(i, pos) {
    if(pos.elementId == idToDel) {
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
  var elemtodel = getElement(idToEdit);
  AppContext.vizdata.removeElement(elemtodel);
  AppContext.vizdata.addElement(newElem);
};

// handle the key pressed events on the input text box
handleKeyPress = function(e) {
  if (!e) e = window.event
  var keyCode = e.keyCode || e.which;
  
  // see if the key entered is a space key or not
  if (keyCode === 32) {
    var currentElementId = '';
    var currentType = '';

    //If the user is adding a new element then hide the input field 
    // and insert a text area to allow a more detailed input
    function handleAddNewElement(){
      $('#newElementText').keypress(function(e){
        //if enter key is pressed, then remove the textarea and save the corresponding element
        if(e.which === 13){
          var newElementDesc = $('#newElementText').val();
          //clean up input dom and hide the text area and show the input box again
          $('#newElementText').fadeOut(2000);
          $('#newElementText').remove();
          $('#newElementText').val('');
          $('#input-elem-search').fadeIn(1000);
          $('#input-elem-search').focus();
          if(AppContext.cluster.addNewElement != '' && newElementDesc!= '' ){
            AppContext.cluster.addNewElement(currentElementId, newElementDesc, currentType);
            return;
          }
        }
      });
    }
    //get the text in the typeahead input, convert it to lower case and split it by space
    var textContent = getNewElementdesc().toLowerCase().split(' '); 
    // check if the first element of the array is of a length less then 2 characters
    if(textContent[0].length < 2){
      $('#input-elem-search').val('');
      $('#input-elem-search').fadeOut(2000);
      $('#edit_input_container').prepend('<textarea row="3" id="newElementText" style="display: none;"></textarea>');
      $('#newElementText').fadeIn(1000);
      $('#newElementText').focus();

      if(textContent[0] == 's'){
        $('#elementsTab li:eq(0) a').tab('show');
        var idstr = "S"+  getNextStoryId();
        currentType = 'stories';
        currentElementId = idstr;
        handleAddNewElement();
        return;
      }  
      else if (textContent[0] == 'f'){
        $('#elementsTab li:eq(1) a').tab('show');
        var idstr = "F"+ getNextForceId();
        currentType = 'forces';
        currentElementId = idstr;
        handleAddNewElement();
        return;
      }
      else if (textContent[0] == 'c'){
        $('#elementsTab li:eq(2) a').tab('show');
        var idstr = "C"+ getNextSolutionId();
        currentType = 'solutionComponents';
        currentElementId = idstr;
        handleAddNewElement();
        return;
      }
      else return;
    } else 
      displayOptions();
  }
}  
