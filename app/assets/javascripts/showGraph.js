addnode = function(elem, i){
  var elemId = elem.elementId;
  var etype = elemId.substr(0,1);
  var color = 'r';
  switch(etype)
  {
    case 'F':
      nodeColor = '#173DBD';
      break;
    case 'S':
      nodeColor = '#F2E41F';
      break;
  }
  try {
  AppContext.menu.sigInst.addNode(elem.elementId,{
      label: elem.elementId,
      color: nodeColor,
      x: i+(Math.random()*0.7),
      y: i+(Math.random()*0.7)
    });
  } catch (msg){
    Util.log.console("Node Already present");
  }
};

sigma.publicPrototype.randomLayout = function() {
    /*var R = 100,
        i = 0,
        L = this.getNodesCount();
 
    this.iterNodes(function(n){
      n.x = Math.cos(Math.PI*(i++)/L)*R;
      n.y = Math.sin(Math.PI*(i++)/L)*R;
    });
 
    return this.position(0,0,1).draw();*/

    var W = 100,
        H = 100;
    
    this.iterNodes(function(n){
      n.x = W*Math.random();
      n.y = H*Math.random();
    });
 
    return this.position(0,0,1).draw();
  };

addedge = function(rel, i){
  try {
    AppContext.menu.sigInst.addEdge(i,rel.srcElementId,rel.targetElementId);
  } catch (msg) {
    Util.log.console("Edge Already present");
  }
};

AppContext.menu.updateGraph = function(){
  if(AppContext.menu.sigInst===undefined){
      AppContext.menu.sigInst = sigma.init($('#sig')[0]).drawingProperties({
        defaultLabelColor: '#ccc',
        font: 'Arial',
        edgeColor: 'source',
        defaultEdgeType: 'curve'
      }).graphProperties({
        minNodeSize: 1,
        maxNodeSize: 10
      });
      
        // Bind events :
      AppContext.menu.sigInst.bind('overnodes',function(event){
        var nodes = event.content;
        var neighbors = {};
        var empty = true;
        AppContext.menu.sigInst.iterEdges(function(e){
          if(nodes.indexOf(e.source)>=0 || nodes.indexOf(e.target)>=0){
            neighbors[e.source] = 1;
            neighbors[e.target] = 1;
            empty = false;
          }
        });
        if(empty){
        } else {
          AppContext.menu.sigInst.iterNodes(function(n){
            if(!neighbors[n.id]){
              n.hidden = 1;
            }else{
              n.hidden = 0;
            }
          });
        }
        AppContext.menu.sigInst.draw();
      }).bind('outnodes',function(){
        AppContext.menu.sigInst.iterEdges(function(e){
          e.hidden = 0;
        }).iterNodes(function(n){
          n.hidden = 0;
        }).draw();
      });

      var elems = AppContext.vizdata.getElements();
      $.map(elems, addnode);
      relations = AppContext.vizdata.getRelations();
      $.map(relations, addedge);
      AppContext.menu.sigInst.randomLayout();
    } else {
      Util.log.console("sigInst is defined");
      AppContext.menu.sigInst.emptyGraph();
      var elems1 = AppContext.vizdata.getElements();
      $.map(elems1, addnode);
      relations = AppContext.vizdata.getRelations();
      $.map(relations, addedge);
      AppContext.menu.sigInst.randomLayout();
      AppContext.menu.sigInst.draw();
      Util.log.console("Refreshed graph");
    }
};

AppContext.menu.showGraph = function() {
  var gbtn = $('#showGraph')[0];
  var action = $(gbtn).attr("value");
  var sigContainer = $('#graphView')[0];
  
  if(action == 'show'){
    $(sigContainer).css("display", "");
    $(gbtn).html("Hide Graph");
    $(gbtn).attr("value","hide");
    AppContext.menu.updateGraph();
    
  } else {
    $(sigContainer).css("display", "none");
    $(gbtn).html("Show Graph");
    $(gbtn).attr("value","show");
  }
};