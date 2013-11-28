  var VizDataModel = function() {};


  /*******************Position methods********************/

  VizDataModel.prototype.getPositions = function() {
    return this.positions.asArray();
  };

  VizDataModel.prototype.addPosition = function(position) {
    Util.log.console("Adding pos:");
    Util.log.console(position);
    this.positions.push(position);
    return this.positions.length;
  };

  var comparator = function (a,b) {
    return (a.posId == b.posId);
  };

  VizDataModel.prototype.removePosition = function(position) {
    var toremove = this.positions.indexOf(position, comparator);
    Util.log.console("To remove index "+toremove);
    this.positions.remove(toremove);
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

  VizDataModel.prototype.isEmpty = function(pos) {
    var temp = AppContext.vizdata.getPositions();
    $(temp).each(function(i){
      if ((this.x == pos.x) && (this.y == pos.y))
        return false;
    });
    return true;
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

  /*******************Element methods********************/

  VizDataModel.prototype.getElements = function() {
    return this.elements.asArray();
  };

  VizDataModel.prototype.addElement = function(element) {
    this.elements.push(element);
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

/*******************Relation methods*********************/

  VizDataModel.prototype.getRelations = function() {
    return this.relations.asArray();
  };

  VizDataModel.prototype.addRelation = function(relation) {
    this.relations.push(relation);
  };

  var relcomparator = function (a,b) {
    return ((a.srcPosId == b.srcPosId)&&(a.targetPosId == b.targetPosId));
  };

  VizDataModel.prototype.removeRelation = function(relation) {
    var toremove = this.relations.indexOf(relation, relcomparator);
    Util.log.console("To remove index in relations "+toremove);
    this.relations.remove(toremove);
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