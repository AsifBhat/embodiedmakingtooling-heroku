var VizDataModel = function() {};
  
VizDataModel.prototype.addPosition = function(position) {
  EM_APP.util.consoleLog("Adding pos:");
  EM_APP.util.consoleLog(position);
  this.positions.push(position);
  EM_APP.util.consoleLog('Position added locally, current count:' +
      this.positions.length);
};

VizDataModel.prototype.getPositions = function() {
  return this.positions.asArray();
};

var comparator = function (a,b) {
  return (a.posId == b.posId);
};

VizDataModel.prototype.removePosition = function(position) {
  var toremove = this.positions.indexOf(position, comparator);
  EM_APP.util.consoleLog("To remove index "+toremove);
  this.positions.remove(toremove);
};

VizDataModel.prototype.getElements = function() {
  return this.elements.asArray();
};

VizDataModel.prototype.addElement = function(element) {
  this.elements.push(element);
};

VizDataModel.prototype.isEmpty = function(pos) {
  var temp = EM_APP.vizdata.getPositions();
  $(temp).each(function(i){
    if ((this.x == pos.x) && (this.y == pos.y))
      return false;
  });
  return true;
};

VizDataModel.prototype.getElementInCell = function(pos) {
  var temp = EM_APP.vizdata.getPositions();
  $(temp).each(function(i){
    if ((this.x == pos.x) && (this.y == pos.y))
      return this.elementId;
  });
};

VizDataModel.prototype.getPositionInCell = function(pos) {
  var temp = EM_APP.vizdata.getPositions();
  $(temp).each(function(i){
    if ((this.x == pos.x) && (this.y == pos.y))
      return this;
  });
};

VizDataModel.prototype.getElementDescription = function(elementId) {
  var temp = EM_APP.vizdata.getElements();
  $(temp).each(function(i){
    if (this.elementId == elementId)
      return this.description;
  });
};

 
/*VizDataModel.prototype.getElementInCell = (pos) ->
 elem = ''
 $.each(EM_APP.vizdata.getPositions(), (i,position) ->
  if (position.x == pos.x) && (position.y == pos.y)  
    elem = position.elementId
 )
 elem

VizDataModel.prototype.getPositionInCell = (pos) ->
  positionToReturn = ''
  $.each(EM_APP.vizdata.getPositions(), (i,position) ->
    if (position.x == pos.x) && (position.y == pos.y)  
      positionToReturn = position
  )
  positionToReturn

VizDataModel.prototype.getElementDescription = (elementId) ->
  description = ''
  $.each(EM_APP.vizdata.getElements(), (i, element)->
    if(element.elementId == elementId)
      description = element.description
      return
  )
  description*/