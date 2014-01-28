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
    var temp = this.getPositions();
    $(temp).each(function(i){
      if ((this.x == pos.x) && (this.y == pos.y)){
        toReturn = this.elementId;
      }
    });
    return toReturn;
  };

  VizDataModel.prototype.isEmpty = function(pos) {
    var toReturn = true;
    var temp = this.getPositions();
    $(temp).each(function(i){
      if ((this.x == pos.x) && (this.y == pos.y))
        toReturn = false;
    });
    return toReturn;
  };

  VizDataModel.prototype.getPositionInCell = function(pos) {
    var toReturn = '';
    var temp = this.getPositions();
    $(temp).each(function(i){
      if ((this.x == pos.x) && (this.y == pos.y))
        toReturn = this;
    });
    return toReturn;
  };

  VizDataModel.prototype.removeAllPositions = function(){
    Util.log.console('Removing all positions');
    this.positions.removeRange(0, this.positions.length);
    return this.positions.length;
  };

  /*******************Element methods********************/

  VizDataModel.prototype.getElements = function() {
    return this.elements.asArray();
  };

  VizDataModel.prototype.isStory = function(elem){
    return (elem.elementId.substr(0,1)=='S');
  };

  VizDataModel.prototype.isForce = function(elem){
    return (elem.elementId.substr(0,1)=='F');
  };

  VizDataModel.prototype.isSolution = function(elem){
    return (elem.elementId.substr(0,1)=='C');
  };

  VizDataModel.prototype.getStories = function() {
    var temp = this.elements.asArray();
    return temp.filter(this.isStory);
  };

  VizDataModel.prototype.getForces = function() {
    var temp = this.elements.asArray();
    return temp.filter(this.isForce);
  };

  VizDataModel.prototype.getSolutions = function() {
    var temp = this.elements.asArray();
    return temp.filter(this.isSolution);
  };

  VizDataModel.prototype.addElement = function(element) {
    this.elements.push(element);
    return this.elements.length;
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

  VizDataModel.prototype.getElementObj = function(elementId) {
    var element = '';
    var temp = AppContext.vizdata.getElements();
    $(temp).each(function(i){
      if (this.elementId == elementId)
        element = this;
    });
    return element;
  };

  VizDataModel.prototype.getContentElementType = function(elementId){
    // if this is returned then the element concerned does not exist anymore 
    var elementObj = this.getElementObj(elementId);
    if(elementObj === '')
      return '';

    if(this.isForce(elementObj)){
      return 'forces';
    }
    else if (this.isStory(elementObj)) {
      return 'stories';
    }
    else if(this.isSolution(elementObj)){
      return 'solutionComponents';
    }
    else
      return '';
  };

  //generic method to remove all the elements from the given instance -- used for import
  VizDataModel.prototype.removeAllElements = function(){
    Util.log.console('removing all content elements');
    this.elements.removeRange(0, this.elements.length);
    return this.elements.length;
  };

  //generic method to add a new set of elements [parameter is an array of elements] -- used for import
  VizDataModel.prototype.insertAllElements = function(importedElements){
    Util.log.console('Adding new content elements');
    this.elements.pushAll(importedElements);
    return this.elements.length;
  };

  // Method to clear all the positional information for a given instance of the worksheet
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
    return this.relations.length;
  };

  var relcomparator = function (a,b) {
    return ((a.srcPosId == b.srcPosId)&&(a.targetPosId == b.targetPosId));
  };

  VizDataModel.prototype.removeRelation = function(relation) {
    var toremove = this.relations.indexOf(relation, relcomparator);
    Util.log.console("To remove index in relations "+toremove);
    this.relations.remove(toremove);
  };

  VizDataModel.prototype.removeAllRelations = function(){
    Util.log.console('removing all relations');
    this.relations.removeRange(0, this.relations.length);
    return this.relations.length;
  };
  
  /************** Meta data methods ***********************/

  VizDataModel.prototype.getTitle = function(){
    var title = "";
    $(this.meta.asArray()).each(function(idx){
      if(this.title !== undefined)
        title = this.title;
    });
    return title;
  };

  VizDataModel.prototype.updateTitle = function(newTitle){
    var removedElem = null;
    $(this.meta.asArray()).each(function(idx){
      if(this.title !== undefined){
        removedElem = this;
        return;
      }
    });
    this.meta.push({"title" : newTitle});
  };

  /************** Nugget methods ***********************/

  /**
    Method to add and persist the nugget corresponding to this document
   */
  VizDataModel.prototype.addNugget = function(nugget){
    Util.log.console('adding nugget: ');
    Util.log.console(nugget);
    this.nuggets.push(nugget);
    return this.nuggets.length;
  };

  /**
    Method to get a list of all the nuggets
   */
  VizDataModel.prototype.getNuggets = function() {
    return this.nuggets.asArray();
  };

  /**
    Remove a nugget: the ID shall be supplied by the UI.
   */
  VizDataModel.prototype.removeNugget = function(nuggetId){
    nuggetsList = this.nuggets.asArray();
    $.each(nuggetsList, function(idx, nugget){
      if(nugget.nuggetId == nuggetId){
        this.nuggets.remove(idx);
        Util.log.console('Deleted nugget with ID' + nuggetId + ' and description nugget.description');
        return;
      }
    });
  }