addnode = function(elem, i){
  var elemId = elem.elementId;
  var etype = elemId.substr(0,1);
  var nodeColor = '8C3E1C';
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
  AppContext.graph.sigInst.addNode(elem.elementId,{
      label: elem.elementId,
      color: nodeColor,
      x: i+(Math.random()*0.7),
      y: i+(Math.random()*0.7)
    });
  } catch (msg){
    Util.log.console("Node Already present");
  }
};

adjustDisplaySize = function(nodeCount) {
  var ratio = Math.round(nodeCount / 20);
  var pixels = ratio * 40;
  var height = 300 + pixels;
  var width = 600 + pixels;
  var sigContainer = $('#graphView')[0];
  $(sigContainer).css("height", height+"px");
  $(sigContainer).css("width", width+"px");

};

sigma.publicPrototype.randomLayout = function() {
  /*  var R = 1000,
        i = 0,
        L = this.getNodesCount();*/
 
    /*this.iterNodes(function(n){
      n.x = Math.cos(Math.PI*(i++)/L)*R;
      n.y = Math.sin(Math.PI*(i++)/L)*R;
    });*/
 
   // return this.position(0,0,1).draw();*/

    var W = 100,
        H = 50;
    
    this.iterNodes(function(n){
      n.x = W*Math.random() ;
      n.y = H*Math.random() ;
    });
 
    return this.position(0,0,1).draw();
  };

addedge = function(rel, i){
  try {
    AppContext.graph.sigInst.addEdge(rel.srcElementId+rel.targetElementId,rel.srcElementId,rel.targetElementId);
  } catch (msg) {
    console.log(msg);
  }
  AppContext.graph.sigInst.draw();
};

removeEdge = function(rel, i){
	  AppContext.graph.sigInst.iterEdges(function(e){
	    if((e.source == rel.srcElementId) && (e.target == rel.targetElementId)){
	      AppContext.graph.sigInst.dropEdge(e.id);
	    }
	  });
	  AppContext.graph.sigInst.draw();
	};

removeNode = function(elem, i){
	AppContext.graph.sigInst.iterNodes(function(n){
	    if((n.id == elem.elementId)){
	      AppContext.graph.sigInst.dropNode(n.id);	      
	    }
	  });
	  AppContext.graph.sigInst.draw();
}

AppContext.graph.updateGraph = function(){
  if(AppContext.graph.sigInst===undefined){
      AppContext.graph.sigInst = sigma.init($('#sig')[0]).drawingProperties({
        defaultLabelColor: '#ccc',
        font: 'Arial',
        edgeColor: 'default',
        defaultEdgeColor: '#000',
        defaultEdgeType: 'curve'
      }).graphProperties({
        minNodeSize: 1,
        maxNodeSize: 10
      });
      
        // Bind events :
      AppContext.graph.sigInst.bind('overnodes',function(event){
        var nodes = event.content;
        var neighbors = {};
        var empty = true;
        AppContext.graph.sigInst.iterEdges(function(e){
          if(nodes.indexOf(e.source)>=0 || nodes.indexOf(e.target)>=0){
            neighbors[e.source] = 1;
            neighbors[e.target] = 1;
            empty = false;
          }
        });
        if(empty){
        } else {
          AppContext.graph.sigInst.iterNodes(function(n){
            if(!neighbors[n.id]){
              n.hidden = 1;
            }else{
              n.hidden = 0;
            }
          });
        }
        AppContext.graph.sigInst.draw();
      }).bind('outnodes',function(){
        AppContext.graph.sigInst.iterEdges(function(e){
          e.hidden = 0;
        }).iterNodes(function(n){
          n.hidden = 0;
        }).draw();
      });

      var elems = AppContext.vizdata.getElements();
      adjustDisplaySize(elems.length);
      $.map(elems, addnode);
      relations = AppContext.vizdata.getRelations();
      $.map(relations, addedge);
      AppContext.graph.sigInst.randomLayout();
      AppContext.graph.sigInst.draw();
      if (document.createEvent) { 
      var ev = document.createEvent('Event');
      ev.initEvent('resize', true, true);
      window.dispatchEvent(ev);
      } else { 
          document.fireEvent('onresize');
      }
    } else {
      AppContext.graph.sigInst.emptyGraph();
      var elems1 = AppContext.vizdata.getElements();
      adjustDisplaySize(elems1.length);
      $.map(elems1, addnode);
      relations = AppContext.vizdata.getRelations();
      $.map(relations, addedge);
      AppContext.graph.sigInst.randomLayout();
      AppContext.graph.sigInst.draw();
      if (document.createEvent) { // W3C
      var ev = document.createEvent('Event');
      ev.initEvent('resize', true, true);
      window.dispatchEvent(ev);
      } else { // IE
          document.fireEvent('onresize');
      }
      Util.log.console("sigInst is defined");
    }
};

AppContext.graph.addElement = function(newElems){
  if(AppContext.graph.sigInst !== undefined) {
    $.map(newElems, addnode);
  }
};

AppContext.graph.addRelation = function(newRelations) {
  if(AppContext.graph.sigInst !== undefined)
    $.map(newRelations, addedge);
};

AppContext.graph.removeElement = function(removedElems){
	if(AppContext.graph.sigInst !== undefined)
	    $.map(removedElems, removeNode);
};

AppContext.graph.removeRelation = function(removedRelations){
  if(AppContext.graph.sigInst !== undefined)
    $.map(removedRelations, removeEdge);
};

AppContext.menu.showGraph = function() {
  var gbtn = $('#showGraph')[0];
  var action = $(gbtn).attr("value");
  var sigContainer = $('#graphView')[0];
  var graphContainer = $('#graphContainer')[0];
  
  if(action == 'show'){
    $(sigContainer).css("display", "");
    $(graphContainer).css("display", "");
    $(gbtn).html("Hide Graph");
    $(gbtn).attr("value","hide");
    AppContext.graph.updateGraph();
    
  } else {
    $(sigContainer).css("display", "none");
    $(graphContainer).css("display", "none");
    $(gbtn).html("Show Graph");
    $(gbtn).attr("value","show");
  }
};