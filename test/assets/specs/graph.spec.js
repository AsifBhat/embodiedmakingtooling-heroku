describe("Graph library", function() {
  var fixture, elem;
  var elements = [{"elementId":"F01", "description":"Force"} ,
                  {"elementId":"F02", "description":"Force"} ,
                  {"elementId":"S01", "description":"Story"}];
  // Relations formed when placing f1, f2, s1 in a row in that order
  var relations = [{"srcElementId": "F02", "targetElementId":"F01"},
                   {"srcElementId": "S01", "targetElementId":"F02"},
                   {"srcElementId": "S01", "targetElementId":"F01"},];
  
  beforeEach(function() {
    //fixture = setFixtures("<div id='graphView' style='display:none;position:absolute;z-index: 1010;height:300px;width:600px;'>    <div id='sig' class='sigma' style='height:100%;width:100%;''></div>  </div>");
  //  $("<div id='graphContainer' style='display:none;overflow:hidden;width:600px;height:300px;position:absolute;z-index:1010;margin-top:100px;margin-left:100px;'>  <div id='graphView' style='display:none;position:absolute;z-index: 1010;height:300px;width:600px;'>    <div id='sig' class='sigma' style='height:100%;width:100%;''></div>  </div> </div> ").appendTo('body');
    fixture = setFixtures("<div id='graphContainer' style='overflow:hidden;width:600px;height:300px;position:absolute;z-index:1010;margin-top:100px;margin-left:100px;'>  <div id='graphView' style='position:absolute;z-index: 1010;height:300px;width:600px;'>    <div id='sig' class='sigma' style='height:100%;width:100%;''></div>  </div> </div> ");
    elem = fixture.find('#graphView')[0];
    spyOn(AppContext.vizdata, 'getElements').andCallFake(function() {
      return elements;
    });
    spyOn(AppContext.vizdata, 'getRelations').andCallFake(function() {
      return relations;
    });
  });

  afterEach(function() {
  });

 /* it("Should initialize graph", function() {
    var siginst = AppContext.graph.initGraph(elem);
    expect(siginst).not.toBe(null);
  });*/
  
});
