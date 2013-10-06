package models

import scalax.collection.Graph

// or scalax.collection.mutable.Graph

import scalax.collection.GraphEdge._

// TODO [AK] Needs some work
case class Cluster(id: String,
                   relations: List[(ContentElement, ContentElement)]) {
  require(relations.length > 0, "Cannot create empty cluster")

  private var clusterGraph = getGraph

  private def getGraph() = {
    val srcnodes = relations map (r => r._1)
    val destnodes = relations map (r => r._2)
    val edges = relations map (r => DiEdge(r._1, r._2))
    val nodes = (srcnodes ::: destnodes).distinct
    Graph.from(nodes, edges)
  }

  def contains(element: ContentElement): Boolean = {
    clusterGraph.find(element) != None
  }

  def getNeighbours(element: ContentElement) = {
    if (clusterGraph.find(element) == None) Set()
    else {
      val edges = clusterGraph.get(element).edges
      val destnodelists = edges.map(e => e.nodes.filter(n => n.value != element))
      destnodelists.map(dnl => dnl.head)
    }
  }

  override def toString() = {
    val clusterString = clusterGraph.edges.toList map (e => "\n" + e.nodes.toList(0).value.id + " --> " + e.nodes.toList(1).value.id)
    clusterString.toString
  }

}

object Cluster {
   private var clusterList : List[Cluster] =    List(
        new Cluster("G0001", List(
        		(SolutionComponent.getElementById("C0001").get, Force.getElementById("F0005").get),
        		(SolutionComponent.getElementById("C0001").get, Force.getElementById("F0006").get),
        		(SolutionComponent.getElementById("C0001").get, Force.getElementById("F0011").get),
        		(SolutionComponent.getElementById("C0001").get, Force.getElementById("F0012").get),
        		(Force.getElementById("F0005").get, Force.getElementById("F0006").get),
        		(Force.getElementById("F0005").get, Force.getElementById("F0004").get),
        		(Force.getElementById("F0005").get, Force.getElementById("F0007").get),
        		(Force.getElementById("F0006").get, Force.getElementById("F0007").get),
        		(Force.getElementById("F0006").get, Force.getElementById("F0013").get),
        		(Force.getElementById("F0004").get, Force.getElementById("F0007").get),
        		(Force.getElementById("F0007").get, Force.getElementById("F0013").get),
        		(Force.getElementById("F0012").get, Force.getElementById("F0011").get))),
        new Cluster("G0002", List(
        		(Story.getElementById("S0004").get, Force.getElementById("F0010").get),
        		(SolutionComponent.getElementById("C0004").get, Force.getElementById("F0011").get),
        		(Force.getElementById("F0010").get, Force.getElementById("F0011").get)))
        
        )
 
   def all():List[Cluster] = {
     clusterList
  }
  
  def getClusterById(id: String): Option[Cluster] = clusterList.find(_.id == id)
}
