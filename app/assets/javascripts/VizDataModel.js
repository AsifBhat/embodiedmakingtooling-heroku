  var VizDataModel = function() {};

  VizDataModel.prototype.addPosition = function(position) {
    Util.log.console("Adding pos:");
    Util.log.console(position);
    this.positions.push(position);
    return this.positions.length;
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
    Util.log.console('Adding Element :');
    Util.log.console(element);
    this.elements.push(element);
  };

  VizDataModel.prototype.isEmpty = function(pos) {
    var temp = AppContext.vizdata.getPositions();
    $(temp).each(function(i){
      if ((this.x == pos.x) && (this.y == pos.y))
        return false;
    });
    return true;
  };

  VizDataModel.prototype.getElementInCell = function(pos) {
    var toReturn = '';
    var temp = AppContext.vizdata.getPositions();
    $(temp).each(function(i){
      if ((this.x == pos.x) && (this.y == pos.y)){
        toReturn = this.elementId;
      }
    });
    return toReturn;
  };

  VizDataModel.prototype.getPositionInCell = function(pos) {
    var toReturn = '';
    var temp = AppContext.vizdata.getPositions();
    $(temp).each(function(i){
      if ((this.x == pos.x) && (this.y == pos.y))
        toReturn = this;
    });
    return toReturn;
  };

  VizDataModel.prototype.getElementDescription = function(elementId) {
    var desc = '';
    var temp = AppContext.vizdata.getElements();
    $(temp).each(function(i){
      if (this.elementId == elementId)
        desc = this.description;
    });
    return desc;
  };
  
  //generic method to remove all the elements from the given instance -- used for import
  VizDataModel.prototype.removeAllElements = function(){
    Util.log.console('removing all content elements');
    this.elements.removeRange(0, this.elements.length);
  }

  //generic method to add a new set of elements [parameter is an array of elements] -- used for import
  VizDataModel.prototype.insertAllElements = function(importedElements){
    Util.log.console('Adding new content elements');
    this.elements.pushAll(importedElements);
  }

  VizDataModel.prototype.removeAllPositions = function(){
    Util.log.console('Removing all positions');
    this.positions.removeRange(0, this.positions.length);    
  }
