describe("File Upload Handler: ", function() {
  var positions = {};
  var elementId = '';
  var fileText = "";

  beforeEach(function() {
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
    AppContext.vizdata = VizDataModel.prototype;
    fileText = "S1115 This is a sample Story- 1\n
      S1116 This is a sample Story- 2\n
      S1111 This is a sample Story- 3\n
      F1112 This is a sample Force- 1\n
      F1113 This is a sample Force- 2\n
      F1114 This is a sample Force- 3";
    /*  
      this.positions = VizDataModel.prototype.positions;
      this.positions.asArray = function(){
        return VizDataModel.prototype.positions;
      };
      fixture = setFixtures('<div id="content-search"><input type="text" name="query"></div>');
      var changeEvent = new Event('onchange');
      changeEvent.initEvent(
          'change', false, false
      );

      document.getElementById('import_file_input').dispatchEvent(changeEvent);
    */
  });
  afterEach(function() {
  });

  it("Should parse file text to give tokens", function() {
    //expect(true).toBe(true);
    readFileText(fileText);
    var numberOfLines = fileText.split('\n').length;
    expect(AppContext.vizdata.getElements()).isEqual(numberOfLines);
  });
});