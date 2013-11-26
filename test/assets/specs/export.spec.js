describe("Export as GEXF", function() {

  beforeEach(function() {
    startRealtime();
    AppContext.vizdata = new VizDataModel();
    spyOn(AppContext.vizdata, 'getElements').andCallFake(function() {
      console.log("Faked call");
      return [{"elementId" : "S0001" , "description" : "We share 10 meeting rooms, usually named after people to identify them, between 300 people, and the meeting rooms need to be kept locked." },
              {"elementId" : "S0002" , "description" : "The receptionist helps book the room, and room users pick up the key, and usually drop it back." }];
    });
  });

  afterEach(function() {
  });

  it("Should return color attribute tag", function() {
    var forcenodecolor = getColoredNode("F01");
		var compnodecolor = getColoredNode("C01");
    expect(forcenodecolor).toEqual("<viz:color r='255'></viz:color>");
    expect(compnodecolor).toEqual("<viz:color b='255'></viz:color>");
  });

  it("Should return colored node tag", function() {
    var nodes = getNodesXml();
    expect(nodes).toEqual("<node id='S0001' label='S0001'><viz:size value='32'></viz:size><viz:color g='255'></viz:color></node><node id='S0002' label='S0002'><viz:size value='32'></viz:size><viz:color g='255'></viz:color></node>");
  });
});