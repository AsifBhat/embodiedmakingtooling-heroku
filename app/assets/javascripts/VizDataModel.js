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
    Util.log.console("To remove pos at index "+toremove);
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

  isStory = function(elem){
    return (elem.elementId.substr(0,1)=='S');
  };

  isForce = function(elem){
    return (elem.elementId.substr(0,1)=='F');
  };

  isSolution = function(elem){
    return (elem.elementId.substr(0,1)=='C');
  };

  VizDataModel.prototype.getStories = function() {
    var temp = this.elements.asArray();
    return temp.filter(isStory);
  };

  VizDataModel.prototype.getForces = function() {
    var temp = this.elements.asArray();
    return temp.filter(isForce);
  };

  VizDataModel.prototype.getSolutions = function() {
    var temp = this.elements.asArray();
    return temp.filter(isSolution);
  };

  VizDataModel.prototype.addElement = function(element) {
    this.elements.push(element);
  };
  
  var elemcomparator = function (a,b) {
    return (a.elementId == b.elementId);
  };

  VizDataModel.prototype.removeElement = function(element) {
    var toremove = this.elements.indexOf(element, elemcomparator);
    Util.log.console("To remove element at index "+toremove);
    this.elements.remove(toremove);
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
  
