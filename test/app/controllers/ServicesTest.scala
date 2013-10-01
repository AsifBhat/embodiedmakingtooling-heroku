package app.controllers

import play.api.test._
import play.api.test.Helpers._
import play.api.libs.ws.WS
import models._
import controllers._
import play.api.libs.json._
import play.api.libs.json.Json._
import rest.BaseSpec
import scala.concurrent.Await
import play.api.libs.functional.syntax._
import play.api.libs.json.Reads._
import models.{Force,Story,SolutionComponent, ClusterEntity, Cluster}

class ServicesTest extends  BaseSpec {
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

  "All Clusters" in {
    running(TestServer(port)) {
      await( WS.url(s"$baseApi/clusters").get, timeout).body must equalTo((obj("clusters" -> ClusterEntity.all)).toString)
    }
  }

  "Cluster By Id" in {
    running(TestServer(port)) {
      var clusterId = ClusterEntity.all.head.id
      await(WS.url(s"$baseApi/clusters/"+ clusterId).get, timeout).body must equalTo((Json.toJson(ClusterEntity.all.head)).toString)
    }
  }  
  
  
  "Create new cluster " in {
    running(TestServer(port)) {
      val result = await(WS.url(s"$baseApi/clusters").post(tempNewClusterWithoutId), timeout)
      result.body must equalTo((tempNewClusterWithId).toString)
      result.status must equalTo(CREATED)
      
    }
  }  
  
  /* ************************************Test Data **********************************/
  
  val base = "/api"
    
  val tempClusters = obj(
      "clusters" -> arr(
        obj(
          "id" -> "G1", 
          "relations" -> arr(
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
          "id" -> "G2",  
          "relations" -> arr(
              obj("element" -> "S0004",
                "relatedElements"-> arr("F0010", "F0011")),
              obj("element" -> "F0010",
                "relatedElements"-> arr("F0011"))
          )
        ),
      obj(
          "id" -> "G3",
          "relations" -> arr(
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
          "id" -> "G4",  
          "relations" -> arr(
              obj("element" -> "S0004",
                "relatedElements"-> arr("F0010")),
              obj("element" -> "F0010",
                "relatedElements"-> arr("F0011")),
              obj("element" -> "F0011",
                "relatedElements"-> arr("F0012"))  
          )
        ),
        obj(
          "id" -> "G5",  
          "relations" -> arr(
              obj("element" -> "S0004",
                "relatedElements"-> arr("F0010","F0011","F0012"))             
          )
        )
      )/*,
      "links" -> arr(
        obj("title" -> "C0001", "href" -> s"$base/solutionComponents/C0001"),
        obj("title" -> "S0004", "href" -> s"$base/stories/S0004"),
        obj("title" -> "F0004", "href" -> s"$base/forces/F0004"),
        obj("title" -> "F0005", "href" -> s"$base/forces/F0005"),
        obj("title" -> "F0006", "href" -> s"$base/forces/F0006"),
        obj("title" -> "F0007", "href" -> s"$base/forces/F0007"),
        obj("title" -> "F0010", "href" -> s"$base/forces/F0010"),
        obj("title" -> "F0011", "href" -> s"$base/forces/F0011"),
        obj("title" -> "F0012", "href" -> s"$base/forces/F0012"),
        obj("title" -> "F0013", "href" -> s"$base/forces/F0013")
      )*/)
      
      val tempNewClusterWithoutId = obj(
          "id" -> "noid",  
          "relations" -> arr(
              obj("element" -> "C0002",
                "relatedElements"-> arr("F0010","F0011"))             
          )
        )
        
      val tempNewClusterWithId = obj(
          "id" -> "G6",  
          "relations" -> arr(
              obj("element" -> "C0002",
                "relatedElements"-> arr("F0010","F0011"))             
          )
        )
  
}
