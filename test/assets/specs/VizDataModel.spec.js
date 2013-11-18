describe("VizDataModel.positions", function() {
  var vizdata;
  var position = {"posId":1, "x":0, "y":0, "elementId":"F01"};
  var fixture, elem;

  beforeEach(function() {
    startRealtime();
    vizdata = new VizDataModel();
    fixture = setFixtures('<div id="hexagonal-grid"></div>');
    elem = fixture.find('#hexagonal-grid')[0];
  });

  afterEach(function() {
  });

  it("Should create a grid", function() {
    //AppContext.grid.createGrid(elem);
    //AppContext.grid.createHex('new');
  });

  it("Vizdata should not be null", function() {
    expect(vizdata).not.toBeNull();
  });

});