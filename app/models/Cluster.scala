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
    val clusterString = (clusterGraph.edges.toList) map (e => "\n" + e.nodes.toList(0).value.id + " --> " + e.nodes.toList(1).value.id)
    clusterString.toString
  }

}
