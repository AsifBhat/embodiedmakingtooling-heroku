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

  it("Should initialize hovered element and tooltip", function() {
    expect(AppContext.grid.initialize().hoveredElement).not.toBeNull();
    expect(AppContext.grid.initialize().idwithtooltip.selector).toEqual('#desctooltip');
  });

  it("Should create a new hex", function() {
    expect(AppContext.grid.createHex('new')).toHaveClass("new");
  });

  it("Should show hovered element", function() {
    expect(AppContext.grid.showHoveredElement(1,2)).toHaveClass("current");
  });

  it("Should place a new element", function() {
    expect(AppContext.grid.placeNewElement(5,5)).toHaveClass("new");
  });

  it("Should show tooltip", function() {
    expect(AppContext.grid.showTooltip(1,2,"This is a sample tooltip")).toHaveData("data-original-title");
  });

  it("Should place an element on the grid", function() {
    expect(AppContext.grid.placeOnGrid(position,"description")).toHaveClass("forces");
  });
  
});


describe("Grid library cluster display", function() {
  var positions = [{"posId":1, "x":0, "y":0, "elementId":"F01"}, {"posId":2, "x":1, "y":0, "elementId":"F02"}] ;

  beforeEach(function() {
    spyOn(AppContext.grid, 'placeOnGrid');
    AppContext.grid.displayAllPositions(positions);
  });

  afterEach(function() {
  });

  it("Should display a list of elements on the grid", function() {
    expect(AppContext.grid.placeOnGrid).toHaveBeenCalled();
    expect(AppContext.grid.placeOnGrid.calls.length).toEqual(2);
  });

  /*it("Should add background if at least one empty neighbour", function() {
    var domelem = AppContext.cluster.markBorder(0,0);
    expect($(domelem)).toHaveClass("bordered");
  });*/
  
  /*it("Should find if top neighbour is empty", function() {
    var bool = isTopEmpty({"x":0,"y":0});
    expect($(domelem)).toHaveClass("bordered");
  });
*/
  
});


