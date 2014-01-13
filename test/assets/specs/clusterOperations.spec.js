xdescribe("Cluster operations - add in empty cell", function() {
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
    AppContext.cluster.updatePosition(null,"F01", 0, 0);
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
    AppContext.cluster.updatePosition(null,"F01", 0, 0);
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

describe('Testing Cluster Operations: ', function() {
  var positions = {};
  var elementId = '';
        
  beforeEach(function() {
    positions.x = 0;
    positions.y = 0;
    elementId = 'F01';
    VizDataModel.prototype.positions = [];
    VizDataModel.prototype.relations = [];
    VizDataModel.prototype.elements = [
      {'elementId' : 'S0001' , 'description' : 'We share 10 meeting rooms, usually named after people to identify them, between 300 people, and the meeting rooms need to be kept locked.' },
      {'elementId' : 'S0002' , 'description' : 'The receptionist helps book the room, and room users pick up the key, and usually drop it back.' },
      {'elementId' : 'S0003' , 'description' : 'Although people are supposed to pick up and drop off the key with me, they rarely do. I have to run around and try and trace where the keys are.' },
      {'elementId' : 'S0004' , 'description' : 'I often have back-to-back meetings, and I donâ€™t always have time to return the key.' },
      {'elementId' : 'S0005' , 'description' : 'We lose keys to meeting rooms all the time and have to replace all the locks 3 or 4 times a year.' },
      {'elementId' : 'S0006' , 'description' : 'We need presentation equipment for meetings.' },
      {'elementId' : 'F01' , 'description' : 'Meeting rooms are shared by a lot of people.'},
      {'elementId' : 'F02' , 'description' : 'Meeting rooms contain expensive equipment.'},
      {'elementId' : 'F03' , 'description' : 'Desire to protect equipment in meeting rooms.'},
      {'elementId' : 'F04' , 'description' : 'Limited number of meeting rooms.'},
      {'elementId' : 'F05' , 'description' : 'Meeting rooms are booked with a single point.'},
      {'elementId' : 'F06' , 'description' : 'Desire to pick up meeting room keys in 1 place.'},
      {'elementId' : 'F07' , 'description' : 'Desire to return keys in 1 place.'},
      {'elementId' : 'F08' , 'description' : 'Tendency for people to not return keys.'},
      {'elementId' : 'F09' , 'description' : 'Difficulty in tracking down unreturned keys.'},
      {'elementId' : 'F10' , 'description' : 'Individuals have several meetings without gaps.'},
      {'elementId' : 'F11' , 'description' : 'Returning keys is often inconvenient'},
      {'elementId' : 'F12' , 'description' : 'Frequent loss of meeting room keys.'},
      {'elementId' : 'F13' , 'description' : 'Inability to distinguish keys of meeting rooms.'},
      {'elementId' : 'F14' , 'description' : 'Use of high-quality equipment in meetings.'}
    ];
    this.positions = VizDataModel.prototype.positions;
    this.positions.asArray = function(){
      return VizDataModel.prototype.positions;
    }

    AppContext.vizdata = VizDataModel.prototype;
  });

  it('testing updatePosition on the cluster by adding a new cell on 0,0 : Position added? ', function() {
    AppContext.cluster.updatePosition(elementId, positions.x, positions.y);
    isPositionPresent = false;
    $.each(VizDataModel.prototype.positions, function(idx, position){
      if(position.elementId == elementId && position.x == positions.x && position.y == positions.y){
        isPositionPresent = true;
        return;
      }
    });
    expect(isPositionPresent).toBe(true);
  });
});


describe("Cluster operations", function() {
  var position = {"posId":"1", "x":0, "y":0, "elementId":"F01"};
  var vizdata;
  var fixtures;

  beforeEach(function() {
    startRealtime();
    AppContext.vizdata = new VizDataModel();
    fixtures = setFixtures('<div class="hex stories" id="1" style="width: 48px; height: 42px; line-height: 42px; left: 108px; top: -63px;">S2</div>');
    spyOn(AppContext.vizdata, 'getPositionInCell').andCallFake(function(pos) {
      return position;
    });
    spyOn(AppContext.cluster,'hasOneEmptyNeighbour').andCallFake(function(pos){
      return true;
    });
  });

  afterEach(function() {
  });

});