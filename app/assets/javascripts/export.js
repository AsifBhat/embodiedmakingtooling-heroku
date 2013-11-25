function exportToGexf() {
  var str = '<gexf version="1.2" xmlns:viz="http://www.gexf.net/1.2draft/viz" xmlns="http://www.gexf.net/1.2draft/viz"><graph mode="static" defaultedgetype="directed"><attributes class="edge"><attribute id="clusterID" title="clusterID" type="string"/></attributes></graph></gexf>';
	var uri = 'data:text/xml;charset=utf-8,' + str;
	var downloadLink = document.createElement("a");
	downloadLink.href = uri;
	downloadLink.download = "clusters.gexf";
	document.body.appendChild(downloadLink);
	downloadLink.click();
	document.body.removeChild(downloadLink);
}

