getColoredNode = function(elemId){
  var etype = elemId.substr(0,1);
  var color = 'r';
  switch(etype)
  {
    case 'S':
      color = 'g';
      break;
    case 'C':
      color = 'b';
      break;
  }
  return "<viz:color "+color+"='255'></viz:color>";
};

getNodesXml = function(){
  var elements = AppContext.vizdata.getElements();
  var elemXml = elements.map(function(elem){return "<node id='"+elem.elementId+"' label='"+elem.elementId+"'><viz:size value='32'></viz:size>"+getColoredNode(elem.elementId)+"</node>";});
  var elemXmlStr = elemXml.join('');
  return elemXmlStr;
};

getEdgesXml = function(){
  var relations = AppContext.vizdata.getRelations();
  var i = 1;
  var edgeXml = relations.map(function(relation){
    var str = "<edge id='";
    str+= i;
    i+=1;
    str+= "' source='";
    str+= relation.srcElementId;
    str+= "' target='";
    str+= relation.targetElementId;
    str+= "' ></edge>";
    return str;
  });
  edgeXmlStr = edgeXml.join('');
  return edgeXmlStr;
};

AppContext.menu.exportToGexf = function() {
  var str = '<gexf version="1.2" xmlns:viz="http://www.gexf.net/1.2draft/viz" xmlns="http://www.gexf.net/1.2draft/viz"><graph mode="static" defaultedgetype="directed"><attributes class="edge"><attribute id="clusterID" title="clusterID" type="string"/></attributes>';
  str+= "<nodes>";
  str+= getNodesXml();
  str+= "</nodes><edges>";
  str+= getEdgesXml();
  str+= "</edges></graph></gexf>";
  var uri = 'data:text/xml;charset=utf-8,' + str;
  var downloadLink = document.createElement("a");
  downloadLink.href = uri;
  downloadLink.download = "clusters.gexf";
  document.body.appendChild(downloadLink);
  downloadLink.click();
  document.body.removeChild(downloadLink);
};

