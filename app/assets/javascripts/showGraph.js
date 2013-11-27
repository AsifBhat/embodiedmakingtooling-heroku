AppContext.menu.showGraph = function() {
  var gbtn = $('#showGraph')[0];
  var action = $(gbtn).attr("value");
  var sigContainer = $('#graphView')[0];
  
  if(action == 'show'){
    $(sigContainer).css("display", "");
    $(gbtn).html("Hide Graph");
    $(gbtn).attr("value","hide");
    AppContext.menu.sigInst = sigma.init($('#sig')[0]).drawingProperties({
      defaultLabelColor: '#ccc',
      font: 'Arial',
      edgeColor: 'source',
      defaultEdgeType: 'curve'
    }).graphProperties({
      minNodeSize: 1,
      maxNodeSize: 10
    });
    // Get all elements
    // call addnode for each element
    // get all relations
    // call addedge for each element
    AppContext.menu.sigInst.addNode('F01',{
      label: 'Lorem Ipsum Lorem Ipsum !',
      color: '#ff0000',
      x: 0.5
    }).addNode('S01',{
      label: 'Lorem Ipsum Lorem Ipsum !',
      color: '#00ff00',
      x: 1.2
    }).addEdge('R01','F01','S01').draw();
    
  } else {
    AppContext.menu.sigInst.emptyGraph();
    $(sigContainer).css("display", "none");
    $(gbtn).html("Show Graph");
    $(gbtn).attr("value","show");
  }
};