describe("Tests for VizDataModel", function() {
  var vizdata;
  var position = {"posId":1, "x":0, "y":0, "elementId":"F01"};

  beforeEach(function() {
    VizDataModel.prototype.positions = [];
    VizDataModel.prototype.relations = [];
    VizDataModel.prototype.elements = [];
    vizdata = new VizDataModel();
  });

  afterEach(function() {
  });

  it("Vizdata is not null", function() {
    expect(vizdata).not.toBeNull();
  });

  /*it("Add a position and remove the same", function() {
    expect(vizdata.addPosition(position)).not.toThrow();
    expect(vizdata.removePosition(position)).not.toThrow();
  });*/
});