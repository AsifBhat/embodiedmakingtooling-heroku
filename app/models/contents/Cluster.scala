package models.contents


import play.api.libs.json._
import play.api.libs.functional.syntax._
import scalax.collection.Graph // or scalax.collection.mutable.Graph
import scalax.collection.GraphPredef._, scalax.collection.GraphEdge._


case class Cluster  (id: String,
                   relations:List[(ContentElement,ContentElement)]){
  require(relations.length>0, "Cannot create empty cluster")
  
  private var clusterGraph = getGraph
  
  private def getGraph () = {   
    val srcnodes = relations map(r => r._1)
    val destnodes = relations map(r=>r._2)
    val edges = relations map(r => DiEdge(r._1,r._2))
    val nodes = (srcnodes:::destnodes).distinct   
    Graph.from(nodes, edges)
  } 
  
  override def toString() = {
    val clusterString = (clusterGraph.edges.toList) map (e => "\n"+e.nodes.toList(0).value.getId+" --> "+e.nodes.toList(1).value.getId) 
    clusterString.toString
  }
 
}
                   
                  
object Cluster {
  
  /*implicit val reader = Json.reads[Cluster]
  implicit val writer = Json.writes[Cluster] */
 
} 