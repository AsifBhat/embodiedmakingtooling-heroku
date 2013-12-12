var to1, to2, to3;

AppContext.controllers.StoriesListCtrl = function ($scope) {
    to1 = setInterval(function () {
        $scope.$apply(function () {
            if(AppContext.vizdata!==undefined){
              var temp =  JSON.stringify(AppContext.vizdata.getStories());
              $scope.stories = JSON.parse(temp);
              Util.log.console($scope.stories)
              clearInterval(to1)
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
              clearInterval(to2)
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
              clearInterval(to3)
            }
        });
    }, 3000);
};

AppContext.menu.showElements = function (){
  var elementsContainer = $('#elementsContainer')[0];
  $(elementsContainer).css("display", "");
};

getNextElemId = function(allElem) {
  var nextId = 1;
  $(allElem).each(function(i){
    var id = this.elementId;
    var numstr = id.substr(1,id.length);
    var num = parseInt(numstr);
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
    
}

getNewElementdesc = function(){
  return $('#newElementText').val().trim();
}

addStory = function() {
  var desc = getNewElementdesc();
  var idstr = "S"+getNextStoryId();
  var elemObj = {"elementId": idstr, "description":desc};
  AppContext.vizdata.addElement(elemObj);
  Util.log.console(elemObj);
};

addForce = function() {
  var desc = getNewElementdesc();
  var idstr = "S"+getNextForceId();
  var elemObj = {"elementId": idstr, "description":desc};
  AppContext.vizdata.addElement(elemObj);
  Util.log.console(elemObj);
};


addSolution = function() {
  var desc = getNewElementdesc();
  var idstr = "S"+getNextSolutionId();
  var elemObj = {"elementId": idstr, "description":desc};
  AppContext.vizdata.addElement(elemObj);
  Util.log.console(elemObj);
};