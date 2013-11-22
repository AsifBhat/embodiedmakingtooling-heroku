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

describe("Vizdata - addPosition", function() {
  var vizdata;
  var position = {"posId":1, "x":0, "y":0, "elementId":"F01"};
 
  beforeEach(function() {
    VizDataModel.prototype.positions = [];
    VizDataModel.prototype.relations = [];
    VizDataModel.prototype.elements = [];
    vizdata = new VizDataModel();
    // dummy functions added for testing purposes
    vizdata.positions.asArray = function(obj){};
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