handleKeyPress = function(e) {
  //console.log("key pressed")
  if (!e) e = window.event
  var keyCode = e.keyCode || e.which
  if (keyCode == '13') {
    $('#addFromTypeahead').css("display","");
    var leftpos = $("#content-search").position().left;
    var toppos = $("#content-search").position().top - 30;
    $('#addFromTypeahead').css("left", leftpos + "px");
    $('#addFromTypeahead').css("top", toppos + "px");
  }      
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
  return $('.twitter-typeahead span').text().trim();
};

addStory = function() {
  var desc = getNewElementdesc();
  var idstr = "S"+getNextStoryId();
  var elemObj = {"elementId": idstr, "description":desc};
  AppContext.vizdata.addElement(elemObj);
  Util.log.console(elemObj);
  var datum = {"value":idstr};
  AppContext.grid.addGridPos(null,datum,'story');
  $('#addFromTypeahead').css("display","none");
};

addForce = function() {
  var desc = getNewElementdesc();
  var idstr = "F"+getNextForceId();
  var elemObj = {"elementId": idstr, "description":desc};
  AppContext.vizdata.addElement(elemObj);
  Util.log.console(elemObj);
  var datum = {"value":idstr};
  AppContext.grid.addGridPos(null,datum,'force');
  $('#addFromTypeahead').css("display","none");
};


addSolution = function() {
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

deleteElem = function(domelem){
  var idtodel = $(domelem).data('elementid');
  Util.log.console("To delete elem:"+idtodel);
  var elemtodel = getElement(idtodel);
  AppContext.vizdata.removeElement(elemtodel);
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
};
  
updateElem = function(domelem)  {
  var idToEdit = domelem.data('elementid');
  var newDesc = $('#elemtext').val().trim();
  var newElem = {"elementId":idToEdit,"description":newDesc};
  Util.log.console("new element:");
  Util.log.console(newElem);
  var elemtodel = getElement(idToEdit);
  AppContext.vizdata.removeElement(elemtodel);
  AppContext.vizdata.addElement(newElem);
};
  

