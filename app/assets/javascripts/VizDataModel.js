var VizDataModel = function() {};
VizDataModel.prototype.positions = gapi.drive.realtime.custom.collaborativeField('positions');
VizDataModel.prototype.relations = gapi.drive.realtime.custom.collaborativeField('relations');
VizDataModel.prototype.elements = gapi.drive.realtime.custom.collaborativeField('elements');
  
VizDataModel.prototype.addPosition = function(position) {
  consoleLog("Adding pos:");
  consoleLog(position);
  this.positions.push(position);
  consoleLog('Position added locally, current count:' +
      this.positions.length);
};
VizDataModel.prototype.getPositions = function() {
  return this.positions.asArray();
};

var comparator = function (a,b) {
  consoleLog(a.posId+" - "+b.posId);
  consoleLog(a.posId == b.posId);
  return (a.posId == b.posId) ;
};

VizDataModel.prototype.removePosition = function(position) {
  var toremove = this.positions.indexOf(position, comparator);
  consoleLog("To remove index "+toremove);
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