describe("Vizdata", function() {
  var vizdata;
  var position = {"posId":1, "x":0, "y":0, "elementId":"F01"};
  
  beforeEach(function() {
    startRealtime();
    vizdata = new VizDataModel();
  });

  afterEach(function() {
  });

  it("Should not be null", function() {
    console.log("vizdata : "+vizdata);
    expect(vizdata).not.toBeNull();
  });
  
});

describe("Vizdata Position CRUD API", function() {
  var vizdata;
  var position = {"posId":1, "x":0, "y":0, "elementId":"F01"};
 
  beforeEach(function() {
    VizDataModel.prototype.positions = [];
    vizdata = new VizDataModel();
    // dummy functions added for testing purposes
    vizdata.positions.asArray = vizdata.positions;
    vizdata.positions.remove = function(obj){};
    spyOn(vizdata.positions, 'asArray').andReturn();
    spyOn(vizdata.positions, 'indexOf').andReturn();
    spyOn(vizdata.positions, 'remove').andReturn();
    
  });
 
  afterEach(function() {
  });

  it("Should get all positions", function() {
    var positions = vizdata.getPositions();
    expect(vizdata.positions.asArray).toHaveBeenCalled();
  });

 
  it("Should add a position", function() {
    var count = vizdata.addPosition(position);
    expect(count).toEqual(1);
  });

  it("Should remove a position", function() {
    var count = vizdata.removePosition(position);
    expect(vizdata.positions.indexOf).toHaveBeenCalled();
    expect(vizdata.positions.remove).toHaveBeenCalled();
  });

});

describe("Vizdata Element CRUD API", function() {
  var vizdata;
  var element = {"elementId":"F01", "description":"This is a sample force element."};
 
  beforeEach(function() {
    VizDataModel.prototype.elements = [];
    vizdata = new VizDataModel();
    // dummy functions added for testing purposes
    vizdata.elements.asArray = vizdata.elements;
    vizdata.elements.remove = function(obj){};
    spyOn(vizdata.elements, 'asArray').andReturn();
    spyOn(vizdata.elements, 'indexOf').andReturn();
    spyOn(vizdata.elements, 'remove').andReturn();
    
  });
 
  afterEach(function() {
  });

  it("Should get all elements", function() {
    var elements = vizdata.getElements();
    expect(vizdata.elements.asArray).toHaveBeenCalled();
  });

 
  it("Should add an element", function() {
    var count = vizdata.addElement(element);
    expect(count).toEqual(1);
  });

  it("Should remove a element", function() {
    var count = vizdata.removeElement(element);
    expect(vizdata.elements.indexOf).toHaveBeenCalled();
    expect(vizdata.elements.remove).toHaveBeenCalled();
  });

});

describe("Vizdata Relations CRUD API", function() {
  var vizdata;
  var relation = {"srcElementId":"F01", "targetElementId":"F02", "srcPosId":"P1", "targetPosId":"P2"};
 
  beforeEach(function() {
    VizDataModel.prototype.relations = [];
    vizdata = new VizDataModel();
    // dummy functions added for testing purposes
    vizdata.relations.asArray = vizdata.relations;
    vizdata.relations.remove = function(obj){};
    spyOn(vizdata.relations, 'asArray').andReturn();
    spyOn(vizdata.relations, 'indexOf').andReturn();
    spyOn(vizdata.relations, 'remove').andReturn();
    
  });
 
  afterEach(function() {
  });

  it("Should get all relations", function() {
    var relations = vizdata.getRelations();
    expect(vizdata.relations.asArray).toHaveBeenCalled();
  });

 
  it("Should add a relation", function() {
    var count = vizdata.addRelation(relation);
    expect(count).toEqual(1);
  });

  it("Should remove a relation", function() {
    var count = vizdata.removeRelation(relation);
    expect(vizdata.relations.indexOf).toHaveBeenCalled();
    expect(vizdata.relations.remove).toHaveBeenCalled();
  });

});



describe("Vizdata Position non-CRUD API", function() {
  var vizdata;
  var position = {"posId":1, "x":0, "y":0, "elementId":"F01"};
 
  beforeEach(function() {
    VizDataModel.prototype.positions = [];
    AppContext.vizdata = new VizDataModel();
    spyOn(AppContext.vizdata, 'getPositions').andCallFake(function() {
      return AppContext.vizdata.positions;
    });
    AppContext.vizdata.positions.removeRange = function(){};
    spyOn(AppContext.vizdata.positions, 'removeRange');
  });
 
  afterEach(function() {
  });

  it("Should get element in cell", function() {
    AppContext.vizdata.addPosition(position);
    var elem = AppContext.vizdata.getElementInCell(position);
    expect(elem).toEqual("F01");
  });

  it("Should find whether cell is empty or not", function() {
    AppContext.vizdata.addPosition(position);
    var isEmpty = AppContext.vizdata.isEmpty({"x":0,"y":0});
    expect(isEmpty).toEqual(false);
    isEmpty = AppContext.vizdata.isEmpty({"x":0,"y":1});
    expect(isEmpty).toEqual(true);
  });

  it("Should get position object in cell", function() {
    AppContext.vizdata.addPosition(position);
    var pos = AppContext.vizdata.getPositionInCell({"x":0,"y":0});
    expect(pos).toEqual(position);
    pos = AppContext.vizdata.getPositionInCell({"x":0,"y":1});
    expect(pos).toEqual('');
  });
  
  it("Should remove all positions", function() {
    AppContext.vizdata.addPosition(position);
    var elem = AppContext.vizdata.removeAllPositions();
    expect(AppContext.vizdata.positions.removeRange).toHaveBeenCalled();
  });

});

describe("Vizdata Element non-CRUD API", function() {
  var vizdata;
  var element = {"elementId":"F01", "description":"This is a sample force element."};
 
  beforeEach(function() {
    VizDataModel.prototype.elements = [];
    vizdata = new VizDataModel();
    // dummy functions added for testing purposes
    vizdata.elements.asArray = vizdata.elements;
    vizdata.elements.remove = function(obj){};
    spyOn(vizdata.elements, 'asArray').andReturn();
    spyOn(vizdata.elements, 'indexOf').andReturn();
    spyOn(vizdata.elements, 'remove').andReturn();
    
  });
 
  afterEach(function() {
  });

  it("Should find type of element", function() {
    var bool = vizdata.isStory({"elementId":"S0001"});
    expect(bool).toEqual(true);
    bool = vizdata.isStory({"elementId":"F0001"});
    expect(bool).toEqual(false);

    bool = vizdata.isForce({"elementId":"F0001"});
    expect(bool).toEqual(true);
    bool = vizdata.isForce({"elementId":"C0001"});
    expect(bool).toEqual(false);

    bool = vizdata.isSolution({"elementId":"C0001"});
    expect(bool).toEqual(true);
    bool = vizdata.isSolution({"elementId":"F0001"});
    expect(bool).toEqual(false);
  });

  /*it("Should get elements of a particular type", function() {
    var stories = vizdata.getStories()
    expect()

  });*/


});