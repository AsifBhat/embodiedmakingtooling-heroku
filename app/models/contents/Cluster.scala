package models.contents


import scalax.collection.Graph // or scalax.collection.mutable.Graph
import scalax.collection.GraphEdge._


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
  
  def contains (element:ContentElement) = { // TODO [AK] It is good practice to list return types
    if (clusterGraph.find(element) != None) false else true // TODO [AK] Do not use return true / false, since this can be simplified
  }
  
  def getNeighbours (element:ContentElement) = {
    if(clusterGraph.find(element) == None) throw new Error("Element not in cluster") // TODO [AK] Throwed exceptions are a pain to handle, let's return an empty set
    else {
      val edges = clusterGraph.get(element).edges
      val destnodelists = edges.map(e => e.nodes.filter(n => n.value!=element))
      destnodelists.map(dnl => dnl.head) 
    }
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