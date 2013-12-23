removeetype = false;

handleKeyPress = function(e) {
  //console.log("key pressed")
  if (!e) e = window.event
  var keyCode = e.keyCode || e.which;
  if (keyCode == '13') {
    var etype = getNewElementdesc().substr(0,1);
    var secondchar = getNewElementdesc().substr(1,1);
    if(secondchar == ' '){
      if((etype == 's')||(etype == 'S')){
    	removeetype = true;
        AppContext.cluster.addStory();
      }  
      else if ((etype == 'f')||(etype == 'F')){
        removeetype = true;
        AppContext.cluster.addForce();
      }
      else if ((etype == 'c')||(etype == 'C')){
        removeetype = true;
        AppContext.cluster.addSolution();
      }  
      else 
    	displayOptions();
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
  return getNextElemId(AppContext.vizdata.getForces());
};

getNextSolutionId =  function() {
  return getNextElemId(AppContext.vizdata.getSolutions());
};


getNewElementdesc = function(){
  var textdesc = $('.twitter-typeahead span').text().trim();
  if(removeetype){
	  textdesc = textdesc.substr(2,textdesc.length-2);
	  removeetype = false;
  }
  console.log(textdesc)
  return textdesc;  
};

AppContext.cluster.addStory = function() {
  var desc = getNewElementdesc();
  var idstr = "S"+getNextStoryId();
  var elemObj = {"elementId": idstr, "description":desc};
  AppContext.vizdata.addElement(elemObj);
  Util.log.console(elemObj);
  var datum = {"value":idstr};
  AppContext.grid.addGridPos(null,datum,'story');
  $('#addFromTypeahead').css("display","none");
};

AppContext.cluster.addForce = function() {
  var desc = getNewElementdesc();
  var idstr = "F"+getNextForceId();
  var elemObj = {"elementId": idstr, "description":desc};
  AppContext.vizdata.addElement(elemObj);
  Util.log.console(elemObj);
  var datum = {"value":idstr};
  AppContext.grid.addGridPos(null,datum,'force');
  $('#addFromTypeahead').css("display","none");
};


AppContext.cluster.addSolution = function() {
  var desc = getNewElementdesc();
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
    if(pos.elementId == idtodel) {
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
  
AppContext.cluster.updateElem = function(domelem)  {
  var idToEdit = domelem.data('elementid');
  var newDesc = $('#elemtext').val().trim();
  var newElem = {"elementId":idToEdit,"description":newDesc};
  Util.log.console("new element:");
  Util.log.console(newElem);
  var elemtodel = getElement(idToEdit);
  AppContext.vizdata.removeElement(elemtodel);
  AppContext.vizdata.addElement(newElem);
};
  

