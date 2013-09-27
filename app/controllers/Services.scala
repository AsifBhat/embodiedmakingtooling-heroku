package controllers

import play.api.mvc._
import play.api.libs.json._
import play.api.libs.json.Json._
import models.{Force,Story,SolutionComponent, ClusterEntity, Cluster}
import scalax.collection.Graph
import play.api.libs.functional.syntax._
import play.api.libs.json.Reads._
import scala.collection.mutable.ListBuffer

object Services extends Controller {
  val baseUrl = "/api"

  implicit val storyReader = reads[Story]
  implicit val storyWriter = writes[Story]
  implicit val forceReader = reads[Force]
  implicit val forceWriter = writes[Force]
  implicit val solutionComponentReader = reads[SolutionComponent]
  implicit val solutionComponentWriter = writes[SolutionComponent]
  implicit val complexreads: Reads[(String,List[String])] = (
		  ((__ \ "element").read[String] and
        (__ \ "relatedElements").read[List[String]]
        tupled)
  )
  implicit val clusterEntityReader = reads[ClusterEntity]
  implicit val complexwrites: Writes[(String,List[String])] = (
		  ((__ \ "element").write[String] and
        (__ \ "relatedElements").write[List[String]]
        tupled)
  )
  implicit val clusterEntityWriter = writes[ClusterEntity] 

 
  def api = Action {
    Ok(prettyPrint(obj("links" -> arr(s"$baseUrl/clusters"))))
  }

  def clusters = Action {
   //prettyPrint(toJson(ClusterEntity.all))\
    val clusters = ClusterEntity.all
    Ok(toJson(obj("clusters" -> clusters)))
  }
  
  def cluster(id: String) = Action {
    Ok(toJson(ClusterEntity.getClusterById(id)))
  }

  def stories = Action {
    Ok(toJson(Story.all()))
  }

  def story(id: String) = Action {
    Ok(toJson(Story.getElementById(id)))
  }

  def forces = Action {
    Ok(toJson(Force.all()))
  }

  def force(id: String) = Action {
    Ok(toJson(Force.getElementById(id)))
  }

  def solutionComponents = Action {
    Ok(toJson(SolutionComponent.all()))
  }

  def solutionComponent(id: String) = Action {
    Ok(toJson(SolutionComponent.getElementById(id)))
  }
  
  def createCluster = Action{ request =>
      val clusterWithoutIdJson = request.body.asJson.get
      val res: JsResult[ClusterEntity] = clusterWithoutIdJson.validate(clusterEntityReader)
      val clusterWithoutId = res.get
      val clusterWithId = ClusterEntity.addClusterToMem(clusterWithoutId)
      Created(toJson(clusterWithId))
  }
  
  def updateCluster (id: String) = Action{ request =>
    val updatedClusterObject = request.body.asJson.get
    val res: JsResult[ClusterEntity] = updatedClusterObject.validate(clusterEntityReader)
    var listOfClusters = ClusterEntity.all
    var updatedCluster = res.get
    ClusterEntity.allClusters = listOfClusters.map( 
        cluster => 
          if(cluster.id == id) updatedCluster else cluster ).asInstanceOf[List[ClusterEntity]]
    println("Updated Cluster: " + ClusterEntity.all)
    Ok("Updated cluster with id " + id)
  }
}
