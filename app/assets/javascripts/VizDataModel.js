  var VizDataModel = function() {};

  VizDataModel.prototype.addPosition = function(position) {
    Util.log.console("Adding pos:");
    Util.log.console(position);
    this.positions.push(position);
    Util.log.console('Position added locally, current count:' +
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
    Util.log.console("To remove index "+toremove);
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
    var toReturn = '';
    var temp = EM_APP.vizdata.getPositions();
    $(temp).each(function(i){
      if ((this.x == pos.x) && (this.y == pos.y)){
        toReturn = this.elementId;
      }
    });
    return toReturn;
  };

  VizDataModel.prototype.getPositionInCell = function(pos) {
    var toReturn = '';
    var temp = EM_APP.vizdata.getPositions();
    $(temp).each(function(i){
      if ((this.x == pos.x) && (this.y == pos.y))
        toReturn = this;
    });
    return toReturn;
  };

  VizDataModel.prototype.getElementDescription = function(elementId) {
    var desc = '';
    var temp = EM_APP.vizdata.getElements();
    $(temp).each(function(i){
      if (this.elementId == elementId)
        desc = this.description;
    });
    return desc;
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