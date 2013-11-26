describe("Cluster operations - add in empty cell", function() {
  var position = {"posId":1, "x":0, "y":0, "elementId":"F01"};
  var vizdata;

  beforeEach(function() {
    startRealtime();
    AppContext.vizdata = new VizDataModel();
    spyOn(AppContext.vizdata, 'getPositionInCell').andCallFake(function(pos) {
      return '';
    });
    spyOn(AppContext.vizdata, 'addPosition').andCallFake(function(pos) {
      return null;
    });
    AppContext.grid.updatePosition(null,"F01", 0, 0);
  });

  afterEach(function() {
  });

  it("Should call getPositionInCell and addPosition", function() {
    expect(AppContext.vizdata.getPositionInCell).toHaveBeenCalled();
    expect(AppContext.vizdata.addPosition).toHaveBeenCalled();
  });
});

xdescribe("Cluster operations - add in non-empty cell", function() {
  var position = {"posId":1, "x":0, "y":0, "elementId":"F01"};
  var vizdata;

  beforeEach(function() {
    startRealtime();
    AppContext.vizdata = new VizDataModel();
    spyOn(AppContext.vizdata, 'getPositionInCell').andCallFake(function(pos) {
      return position;
    });
    spyOn(AppContext.vizdata, 'addPosition').andCallFake(function(pos) {
      return null;
    });
    spyOn(AppContext.vizdata, 'removePosition').andCallFake(function(pos) {
      return null;
    });
    AppContext.grid.updatePosition(null,"F01", 0, 0);
  });

  afterEach(function() {
  });

  it("Should call getPositionInCell and addPosition", function() {
    expect(AppContext.vizdata.getPositionInCell).toHaveBeenCalled();
    expect(AppContext.vizdata.removePosition).toHaveBeenCalled();
    expect(AppContext.vizdata.addPosition).toHaveBeenCalled();
  });
});

xdescribe("Cluster operations - delete an element from a cell", function() {
  var position = {"posId":1, "x":0, "y":0, "elementId":"F01"};
  var vizdata;

  beforeEach(function() {
    startRealtime();
    AppContext.vizdata = new VizDataModel();
    spyOn(AppContext.vizdata, 'getPositionInCell').andCallFake(function(pos) {
      return position;
    });
    spyOn(AppContext.vizdata, 'removePosition').andCallFake(function(pos) {
      return null;
    });
    AppContext.grid.deletePosition(null,"F01", 0, 0);
  });

  afterEach(function() {
  });

  it("Should call getPositionInCell, removePosition", function() {
    expect(AppContext.vizdata.getPositionInCell).toHaveBeenCalled();
    expect(AppContext.vizdata.removePosition).toHaveBeenCalled();
  });
});

