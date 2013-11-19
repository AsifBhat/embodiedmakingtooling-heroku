describe("Vizdata", function() {
  var vizdata;
  
  beforeEach(function() {
    startRealtime();
    vizdata = new VizDataModel();
  });

  afterEach(function() {
  });

  it("Should not be null", function() {
    expect(vizdata).not.toBeNull();
  });

});