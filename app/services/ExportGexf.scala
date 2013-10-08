package services

import models._

object ExportGexf {
  def export =
    <gexf xmlns="http://www.gexf.net/1.2draft/viz" version="1.2"
          xmlns:viz="http://www.gexf.net/1.2draft/viz">
      <graph mode="static" defaultedgetype="directed">
        <attributes class="node">
          <attribute id="description" title="description" type="string"></attribute>
        </attributes>
        <attributes class="edge">
          <attribute id="cluster" title="cluster" type="string"/>
        </attributes>
        <nodes>
          {for (n <- Force.all()) yield
          <node id={n.id} label={n.id}>
            <attvalues>
              <attvalue for="description" value={n.description}/>
            </attvalues>
            <viz:size value="32"></viz:size>
            <viz:shape value="square"/>
            <viz:color r="255" g="0" b="0"></viz:color>
          </node>}{for (n <- Story.all()) yield
          <node id={n.id} label={n.id}>
            <attvalues>
              <attvalue for="description" value={n.description}/>
            </attvalues>
            <viz:size value="32"></viz:size>
            <viz:shape value="square"/>
            <viz:color r="0" g="255" b="0"></viz:color>
          </node>}{for (n <- SolutionComponent.all()) yield
          <node id={n.id} label={n.id}>
            <attvalues>
              <attvalue for="description" value={n.description}/>
            </attvalues>
            <viz:size value="32"></viz:size>
            <viz:shape value="diamond"/>
            <viz:color r="0" g="0" b="255"></viz:color>
          </node>}
        </nodes>
        <edges>
          {var i = 0
        for (clusterEntity <- ClusterEntity.all) yield {
          val cluster = clusterEntity.getCluster
          for (rel <- cluster.relations) yield {
            i = i + 1
            <edge id={i.toString} source={rel._1.id} target={rel._2.id}>
              <attvalues>
                <attvalue for="cluster" value={cluster.id}/>
              </attvalues>
              <viz:color r="157" g="213" b="78"/>
              <viz:thickness value="10"/>
              <viz:shape value="double"/>
            </edge>
          }
        }}
        </edges>
      </graph>
    </gexf>
}