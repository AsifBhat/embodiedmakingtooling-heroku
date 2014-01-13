getColoredNode = function(elemId){
  var etype = elemId.substr(0,1);
  var color = "r = '242' g='215' b='10'";
  switch(etype)
  {
    case 'F':
      color = "r = '40' g='62' b='224'";
      break;
    case 'C':
      color = "r = '140' g='106' b='52'";
      break;
  }
  return "<viz:color "+color+"></viz:color>";
};

getNodesXml = function(){
  var elements = AppContext.vizdata.getElements();
  var elemXml = elements.map(function(elem){return "<node id='"+elem.elementId+"' label='"+elem.description+"' description='"+elem.description+"'><viz:size value='32'></viz:size>"+getColoredNode(elem.elementId)+"</node>";});
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

AppContext.exports.exportToGexf = function() {
  var str = '<gexf version="1.2" xmlns:viz="http://www.gexf.net/1.2draft/viz" xmlns="http://www.gexf.net/1.2draft/viz"><graph mode="static" defaultedgetype="directed"><attributes class="node"><attribute id="description" title="Description" type="string"/></attributes>';
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


AppContext.exports.exportElements = function() {
  var elements = AppContext.vizdata.getElements();
  var strarr = elements.map(function(e){return e.elementId+" "+e.description+"%0D%0A" ;});
  var str = strarr.join("\r\n");
  //var str = "\n\r\n\n\n\n";
  var uri = 'data:text/plain;charset=utf-16,' + str;
  var downloadLink = document.createElement("a");
  downloadLink.href = uri;
  downloadLink.download = "Content Elements.txt";
  console.log(str);
  document.body.appendChild(downloadLink);
  downloadLink.click();
  document.body.removeChild(downloadLink);
};
