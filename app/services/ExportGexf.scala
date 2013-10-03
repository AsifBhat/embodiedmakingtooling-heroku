package services

import scala.xml._
import scala.xml.factory
import models._
import scala.xml.PrettyPrinter

object ExportGexf {
  
def export (fileName: String) = { 
  
val xmlString = <gexf xmlns="http://www.gexf.net/1.2draft/viz" version="1.2"
                      xmlns:viz="http://www.gexf.net/1.2draft/viz">
  <graph mode="static" defaultedgetype="directed">
  	<attributes class="edge">
      <attribute id="clusterID" title="clusterID" type="string"/>
    </attributes>
	<nodes>
  {for(n <- Force.all) yield 
    <node id={n.id} label={n.id}>
      <viz:size value="32"></viz:size>
      <viz:shape value="square" />
      <viz:color r="255" g="0" b="0"></viz:color>
    </node>}
  {for(n <- Story.all) yield 
    <node id={n.id} label={n.id}>
      <viz:size value="32"></viz:size>
      <viz:shape value="square" />
      <viz:color r="0" g="255" b="0"></viz:color> </node>}
  {for(n <- SolutionComponent.all) yield 
    <node id={n.id} label={n.id}>
      <viz:size value="32"></viz:size>
      <viz:shape value="diamond" />
      <viz:color r="0" g="0" b="255"></viz:color>
    </node>}
  </nodes>
  <edges>
    {
      var i = 0
      for (clusterEntity <- ClusterEntity.all) yield {
        val cluster = clusterEntity.getCluster        
        for(rel <- cluster.relations) yield {
          i=i+1
          <edge id={i.toString} source={rel._1.id} target={rel._2.id} >
          	<attvalues>
              <attvalue for="0" value={cluster.id}/>
            </attvalues>
            <viz:color r="157" g="213" b="78"/>
            <viz:thickness value="10"/>
            <viz:shape value="double"/>
          </edge>
        }
      }
    } 
  </edges>
  </graph>
  </gexf>;
    
  val file =   XML.save(fileName, xmlString )  // Need to append file name if folder name is supplied
}
}