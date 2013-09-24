package controllers

import play.api.mvc._
import play.api.libs.json._
import play.api.libs.json.Json._
import models.{Force,Story,SolutionComponent, ClusterEntity}
import scalax.collection.Graph
import play.api.libs.functional.syntax._
import play.api.libs.json.Reads._

object Services extends Controller {
  val baseUrl = "/api"

  implicit val storyReader = reads[Story]
  implicit val storyWriter = writes[Story]
  implicit val forceReader = reads[Force]
  implicit val forceWriter = writes[Force]
  implicit val solutionComponentReader = reads[SolutionComponent]
  implicit val solutionComponentWriter = writes[SolutionComponent]
  implicit val clusterEntityReader = reads[ClusterEntity]
  
  
  implicit val complexreads: Reads[(String,List[String])] = (
      (__ \ "graph").read (
		((__ \ "element").read[String] and
        (__ \ "relatedElements").read[List[String]]
        tupled) 
        )
  ) 

  var tempCounter = 6
  val tempClusters = obj(
      "clusters" -> arr(
        obj(
          "clusterId" -> "G0001", 
          "graph" -> arr(
           obj("element" -> "C0001",
                "relatedElements"-> arr("F0005", "F0006", "F0011", "F0012")),
           obj("element" -> "F0005",
                "relatedElements"-> arr("F0006", "F0004", "F0007")),
           obj("element" -> "F0006",
                "relatedElements"-> arr("F0007", "F0013")),
           obj("element" -> "F0004",
                "relatedElements"-> arr("F0007")),
           obj("element" -> "F0007",
                "relatedElements"-> arr("F0013")),
           obj("element" -> "F0012",
                "relatedElements"-> arr("F0011"))
          )
        ),
        obj(
          "clusterId" -> "G0002",  
          "graph" -> arr(
              obj("element" -> "S0004",
                "relatedElements"-> arr("F0010", "F0011")),
              obj("element" -> "F0010",
                "relatedElements"-> arr("F0011"))
          )
        ),
      obj(
          "clusterId" -> "G0003",
          "graph" -> arr(
           obj("element" -> "C0001",
                "relatedElements"-> arr("F0005", "F0006", "F0011", "F0012")),
           obj("element" -> "F0005",
                "relatedElements"-> arr("F0006", "F0004", "F0007")),
           obj("element" -> "F0006",
                "relatedElements"-> arr("F0007", "F0013")),
           obj("element" -> "F0004",
                "relatedElements"-> arr("F0007")),
           obj("element" -> "F0007",
                "relatedElements"-> arr("F0013")),
           obj("element" -> "F0012",
                "relatedElements"-> arr("F0011"))
          )
        ),
        obj(
          "clusterId" -> "G0004",  
          "graph" -> arr(
              obj("element" -> "S0004",
                "relatedElements"-> arr("F0010")),
              obj("element" -> "F0010",
                "relatedElements"-> arr("F0011")),
              obj("element" -> "F0011",
                "relatedElements"-> arr("F0012"))  
          )
        ),
        obj(
          "clusterId" -> "G0005",  
          "graph" -> arr(
              obj("element" -> "S0004",
                "relatedElements"-> arr("F0010","F0011","F0012"))             
          )
        )
      ),
      "links" -> arr(
        obj("title" -> "C0001", "href" -> s"$baseUrl/solutionComponents/C0001"),
        obj("title" -> "S0004", "href" -> s"$baseUrl/stories/S0004"),
        obj("title" -> "F0004", "href" -> s"$baseUrl/forces/F0004"),
        obj("title" -> "F0005", "href" -> s"$baseUrl/forces/F0005"),
        obj("title" -> "F0006", "href" -> s"$baseUrl/forces/F0006"),
        obj("title" -> "F0007", "href" -> s"$baseUrl/forces/F0007"),
        obj("title" -> "F0010", "href" -> s"$baseUrl/forces/F0010"),
        obj("title" -> "F0011", "href" -> s"$baseUrl/forces/F0011"),
        obj("title" -> "F0012", "href" -> s"$baseUrl/forces/F0012"),
        obj("title" -> "F0013", "href" -> s"$baseUrl/forces/F0013")
      ))
  

  def api = Action {
    Ok(prettyPrint(obj("links" -> arr(s"$baseUrl/clusters"))))
  }

  def clusters = Action {
    prettyPrint(tempClusters)
    Ok((tempClusters))
  }
  
  def cluster(id: String) = Action {
    var x = 0
    var toReturn = (tempClusters \ "clusters" )(0)
    for( x <- 0 to 4 ){
    	val t = (tempClusters \ "clusters" )(x)
    	if ((t \ "clusterId").toString == id)
    	  toReturn = t
    }
    Ok(toReturn)
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
   	val requestBodyAsJson = scala.util.parsing.json.JSON.parseFull(request.body.asJson.getOrElse().toString)
      
   	var requestMapObject = requestBodyAsJson.getOrElse() //fetch the map containing 'graph'
    //println(clusterObject + " JSON String: " + request.body.asJson.getOrElse().toString)
   // Created("Created Cluster")
  val clusterWithoutIdJson = request.body.asJson.get
  val clusterWithoutId: JsResult[ClusterEntity] = clusterWithoutIdJson.validate(clusterEntityReader)
  val nextId = "G000".concat(tempCounter.toString)
  Ok(clusterWithoutId.toString)
  }
  
  def updateCluster (id: String) = Action{
    Ok("Updated cluster with id " + id)
  }
}
