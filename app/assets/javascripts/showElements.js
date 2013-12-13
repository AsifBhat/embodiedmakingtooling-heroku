var to1, to2, to3;

AppContext.controllers.StoriesListCtrl = function ($scope) {
    to1 = setInterval(function () {
        $scope.$apply(function () {
            if(AppContext.vizdata!==undefined){
              var temp =  JSON.stringify(AppContext.vizdata.getStories());
              $scope.stories = JSON.parse(temp);
              Util.log.console($scope.stories);
              clearInterval(to1);
            }
        });
    }, 3000);
};

AppContext.controllers.ForcesListCtrl = function ($scope) {
  to2 = setInterval(function () {
        $scope.$apply(function () {
            if(AppContext.vizdata!==undefined){
              var temp =  JSON.stringify(AppContext.vizdata.getForces());
              $scope.forces = JSON.parse(temp);
              clearInterval(to2);
            }
        });
    }, 3000);
};

AppContext.controllers.SolutionsListCtrl = function ($scope) {
  to3 = setInterval(function () {
        $scope.$apply(function () {
            if(AppContext.vizdata!==undefined){
              var temp =  JSON.stringify(AppContext.vizdata.getSolutions());
              $scope.solutions = JSON.parse(temp);
              clearInterval(to3);
            }
        });
    }, 3000);
};

AppContext.menu.showElements = function (){
  
  $(elementsContainer).css("display", "");
  var ebtn = $('#showElements')[0];
  var action = $(ebtn).attr("value");
  var elementsContainer = $('#elementsContainer')[0];
  
  if(action == 'show'){
    $(elementsContainer).css("display", "");
    $(ebtn).html("Hide Elements");
    $(ebtn).attr("value","hide");
    AppContext.menu.updateGraph();
    
  } else {
    $(elementsContainer).css("display", "none");
    $(ebtn).html("Show Elements");
    $(ebtn).attr("value","show");
  }
};

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

enableButtons = function(value){
    if(value.trim().length>0){
      $('#addElementsbtn .btn').removeClass('disabled');
    } else {
      $('#addElementsbtn .btn').addClass('disabled');
    }
    
};

getNewElementdesc = function(){
  if (($('#newElementText').val().trim().length)===0)
    return $('.twitter-typeahead span').text().trim();
  else
    return $('#newElementText').val().trim();
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
  

