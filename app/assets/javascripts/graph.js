addnode = function(elem, i){
  var elemId = elem.elementId;
  var etype = elemId.substr(0,1);
  var nodeColor = '#8C3E1C';
  switch(etype)
  {
  case 'F':
    nodeColor = '#173DBD';
    break;
  case 'S':
    nodeColor = '#F2E41F';
    break;
  }
  AppContext.graph.sigInst.graph.addNode({
    id: elem.elementId,
    label: elem.elementId,
    x: Math.random(),
    y: Math.random(),
    size: 1,
    color: nodeColor
  });
  AppContext.graph.sigInst.refresh();
};

removeNode = function(elem, i){
  var g = AppContext.graph.sigInst.graph.dropNode(elem.elementId);
  AppContext.graph.sigInst.refresh();
};

addedgetograph = function(src,target,i){
  try{
    AppContext.graph.sigInst.graph.addEdge({
      id: src+target+i,
      source: src,
      target: target,
      size: 1,
      color: '#000'
    });
    
  } catch (e) {
    Util.log.console(e);
    addedgetograph(src,target,i+1);
  }
};

addedge = function(rel, i){
  addedgetograph(rel.srcElementId, rel.targetElementId, 0);
  AppContext.graph.sigInst.refresh();
};

removeedgefromgraph = function(src,target,i){
  try{
    AppContext.graph.sigInst.graph.dropEdge(src+target+i);
    AppContext.graph.sigInst.refresh();
  } catch (e){
    removeedgefromgraph(src,target,i+1);
  }
};

removeEdge = function(rel, i){
  removeedgefromgraph(rel.srcElementId,rel.targetElementId,0);
};

fireResizeEvent = function(){
  if (document.createEvent) {
      var ev = document.createEvent('Event');
      ev.initEvent('resize', true, true);
      window.dispatchEvent(ev);
    } else {
      document.fireEvent('onresize');
    }
};

adjustDisplaySize = function(nodeCount) {
  var ratio = Math.round(nodeCount / 20);
  var pixels = ratio * 50;
  var height = 300 + pixels;
  var width = 600 + pixels;
  var sigContainer = $('#graphView')[0];
  $(sigContainer).css("height", height+"px");
  $(sigContainer).css("width", width+"px");
};

AppContext.graph.initGraph = function(gcontainer){
  if(AppContext.graph.sigInst===undefined){
    var elems = AppContext.vizdata.getElements();
    var relations = AppContext.vizdata.getRelations();
    /*AppContext.graph.sigInst.bind('overNode outNode clickNode', function(e) {
      //e.data.node.
          //Util.log.console(e.type, e.data);
    });*/
   
    AppContext.graph.graph = {
          nodes: [],
          edges: []
      };
    AppContext.graph.sigInst = new sigma({
        graph: AppContext.graph.graph,
        container: gcontainer/*,
        settings: {drawEdges: false}*/
    });
    adjustDisplaySize(elems.length);
    $.map(elems, addnode);
    $.map(relations, addedge);
    AppContext.graph.sigInst.refresh();
    fireResizeEvent();
  }
  return AppContext.graph.sigInst;
};

AppContext.graph.addElement = function(newElems){
  if(AppContext.graph.sigInst !== undefined) {
    $.map(newElems, addnode);
  }
};

AppContext.graph.addRelation = function(newRelations) {
  if(AppContext.graph.sigInst !== undefined){
    $.map(newRelations, addedge);
    AppContext.graph.sigInst.refresh();
  }
};

AppContext.graph.removeElement = function(removedElems){
  if(AppContext.graph.sigInst !== undefined)
    $.map(removedElems, removeNode);
};

AppContext.graph.removeRelation = function(removedRelations){
  if(AppContext.graph.sigInst !== undefined)
    $.map(removedRelations, removeEdge);
};

AppContext.graph.showGraph = function() {
  var gbtn = $('#showGraph')[0];
  var action = $(gbtn).attr("value");
  var sigContainer = $('#graphView')[0];
  var graphContainer = $('#graphContainer')[0];

  if(action == 'show'){
    $(sigContainer).css("display", "");
    $(graphContainer).css("display", "");
    $(gbtn).html('<span class="icon-eye-close"></span> &nbsp; Hide Graph');
    $(gbtn).attr("value","hide");
    AppContext.graph.initGraph($('#graphView')[0]);

  } else {
    $(sigContainer).css("display", "none");
    $(graphContainer).css("display", "none");
    $(gbtn).html('<span class="icon-eye-open"></span>Show Graph');
    $(gbtn).attr("value","show");
  }
};
