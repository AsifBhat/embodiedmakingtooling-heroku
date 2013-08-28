package models.contents


import play.api.libs.json._
import play.api.libs.functional.syntax._
import scalax.collection.Graph // or scalax.collection.mutable.Graph
import scalax.collection.GraphPredef._, scalax.collection.GraphEdge._


case class Cluster  (id: String,
                   relations:List[String]){
  require(relations.length>0, "Cannot create empty cluster")
  
  private var clusterGraph = getGraph
  
  private def getGraph () = {
    val elements = relations map (r => ((r.trim().split("-"))(0),((r.trim().split("-"))(1)).dropWhile(c => c=='>').tail))
    val edges = elements map(e => DiEdge(e._1,e._2))
    val srcnodes = elements map(e => e._1)
    val nodes = (srcnodes:::(elements map(e => e._1)))
    val distinctnodes = nodes.distinct
    /*println(elements)
    println(nodes)
    println(distinctnodes)*/
    Graph.from(nodes, edges)
  } 
  
  def contains(elementId: String) = {
    /*println("Checking for elem "+elementId+" result: "+clusterGraph.find(elementId))*/
    if(clusterGraph.find(elementId) == None) false
    else true
  }
}
                   
                  
object Cluster {
 /* var clusters = List(new Cluster("G0001",List("F0005->F0006","F0006->F0007","F0007-F0003","F0003->F0004","F0004->F0008","F0008->F0009","F0009","F0010","F0012","F0013")),
		new Cluster("G0002",List("F0003","F0008","F0009","F0012","F0013")),
		new Cluster("G0003",List("F0005","F0001","F0004","F0011","F0012","F0013")),
		new Cluster("G0004",List("F0001","F0002","F0005","F0006","F0007","F0008","F0009","F0011","F0012"))		
		)*/
  //def apply(bar: Int) = new Foo(bar)
  
  /*def all(): List[Cluster] = {
		clusters
  }
  
  def add(newClusters:List[Cluster]): List[Cluster] = {
    clusters:::newClusters
  }*/
  
  implicit val reader = Json.reads[Cluster]
  implicit val writer = Json.writes[Cluster] 
  	
  /*def createCluster(): Cluster{
    val gA = Graph(3~>1.2)
  }*/
} 