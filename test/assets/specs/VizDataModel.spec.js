describe("VizDataModel.positions", function() {
  var vizdata;
  var position = {"posId":1, "x":0, "y":0, "elementId":"F01"};


  beforeEach(function() {
    startRealtime();
    jasmine.getFixtures().fixturesPath = './fixtures';
    vizdata = new VizDataModel();
    loadFixtures('EMtool.html');
  });

  afterEach(function() {
    domelem.remove();
    domelem = null;
  });

  it("Should create a grid", function() {
    AppContext.grid.createGrid($('#hexagonal-grid')[0]);
  });

  it("Vizdata should not be null", function() {
    expect(vizdata).not.toBeNull();
  });

});