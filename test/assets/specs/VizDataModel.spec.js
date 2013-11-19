describe("Grid library", function() {
  var position = {"posId":1, "x":0, "y":0, "elementId":"F01"};
  var fixture, elem;

  beforeEach(function() {
    fixture = setFixtures('<div id="hexagonal-grid"></div>');
    elem = fixture.find('#hexagonal-grid')[0];
  });

  afterEach(function() {
  });

  it("Should create a grid", function() {
    expect(AppContext.grid.createGrid(elem)).toEqual(AppContext.grid.grid.size);
  });

  it("Should create a new hex", function() {
    //console.log("grid: "+AppContext.grid.createGrid(elem));
    expect(AppContext.grid.createHex('new')).toHaveClass("new");
  });

});

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