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
  console.log(elements);
  var elemXml = elements.map(function(elem){return "<node id='"+elem.elementId+"' label='"+elem.elementId+"'><viz:size value='32'></viz:size>"+getColoredNode(elem.elementId)+"</node>";});
  var elemXmlStr = elemXml.join('');
  return elemXmlStr;
};

AppContext.menu.exportToGexf = function() {
  var str = '<gexf version="1.2" xmlns:viz="http://www.gexf.net/1.2draft/viz" xmlns="http://www.gexf.net/1.2draft/viz"><graph mode="static" defaultedgetype="directed"><attributes class="edge"><attribute id="clusterID" title="clusterID" type="string"/></attributes>';
  str+= "<nodes>";
  str+= getNodesXml();
  str+= "</nodes>";
  str+= "</graph></gexf>";
  var uri = 'data:text/xml;charset=utf-8,' + str;
  var downloadLink = document.createElement("a");
  downloadLink.href = uri;
  downloadLink.download = "clusters.gexf";
  document.body.appendChild(downloadLink);
  downloadLink.click();
  document.body.removeChild(downloadLink);
};

