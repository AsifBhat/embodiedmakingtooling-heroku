package models.contents


import play.api.libs.json._
import play.api.libs.functional.syntax._


case class Cluster  (id: String,
                   contentElements:List[String]){
  require(contentElements.length>0, "Cannot create empty cluster")
}
                   
                  
object Cluster {
  var clusters = List(new Cluster("G0001",List("F0005","F0006","F00007","F0003","F0004","F0008","F0009","F0010","F0012","F0013")),
		new Cluster("G0002",List("F0003","F0008","F0009","F0012","F0013")),
		new Cluster("G0003",List("F0005","F0001","F0004","F0011","F0012","F0013")),
		new Cluster("G0004",List("F0001","F0002","F0005","F0006","F0007","F0008","F0009","F0011","F0012"))		
		)
  
  def all(): List[Cluster] = {
		clusters
  }
  
  def add(newClusters:List[Cluster]): List[Cluster] = {
    clusters:::newClusters
  }
  	implicit val reader = Json.reads[Cluster]
	implicit val writer = Json.writes[Cluster] 
} 