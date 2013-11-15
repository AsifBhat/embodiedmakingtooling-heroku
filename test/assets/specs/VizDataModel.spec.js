describe("VizDataModel.positions", function() {
  var vizdata;
  var position = {"posId":1, "x":0, "y":0, "elementId":"F01"};

  beforeEach(function() {
    startRealtime();
    vizdata = new VizDataModel();
  });

  afterEach(function() {
  });

  it("Vizdata should not be null", function() {
    expect(vizdata).not.toBeNull();
  });

});