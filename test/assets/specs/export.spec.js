describe("Export as GEXF", function() {

  beforeEach(function() {
    AppContext.vizdata = new VizDataModel();
    spyOn(AppContext.vizdata, 'getElements').andCallFake(function() {
      return [{"elementId" : "S0001" , "description" : "We share 10 meeting rooms, usually named after people to identify them, between 300 people, and the meeting rooms need to be kept locked." },
              {"elementId" : "S0002" , "description" : "The receptionist helps book the room, and room users pick up the key, and usually drop it back." }];
    });
    spyOn(AppContext.vizdata, 'getRelations').andCallFake(function() {
      console.log("Faked call");
      return [{srcElementId: "S0004", targetElementId: "S0002", srcPosId: 2, targetPosId: 1},
              {srcElementId: "S0002", targetElementId: "S0001", srcPosId: 1, targetPosId: 0}];
    });
  });

  afterEach(function() {
  });

  it("Should return color attribute tag", function() {
    var forcenodecolor = getColoredNode("F01");
		var compnodecolor = getColoredNode("C01");
    expect(forcenodecolor).toEqual("<viz:color r = '40' g='62' b='224'></viz:color>");
    expect(compnodecolor).toEqual("<viz:color r = '140' g='106' b='52'></viz:color>");
  });

  it("Should return colored node tag with description label", function() {
    var nodes = getNodesXml();
    expect(nodes).toEqual("<node id='S0001' label='We share 10 meeting rooms, usually named after people to identify them, between 300 people, and the meeting rooms need to be kept locked.' description='We share 10 meeting rooms, usually named after people to identify them, between 300 people, and the meeting rooms need to be kept locked.'><viz:size value='32'></viz:size><viz:color r = '242' g='215' b='10'></viz:color></node><node id='S0002' label='The receptionist helps book the room, and room users pick up the key, and usually drop it back.' description='The receptionist helps book the room, and room users pick up the key, and usually drop it back.'><viz:size value='32'></viz:size><viz:color r = '242' g='215' b='10'></viz:color></node>");
  });

  it("Should return xml for an edge", function() {
    var edges = getEdgesXml();
    expect(edges).toEqual("<edge id='1' source='S0004' target='S0002' ></edge><edge id='2' source='S0002' target='S0001' ></edge>");
  });
});