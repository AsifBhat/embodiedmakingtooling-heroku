package app.controllers

import play.api.test._
import play.api.test.Helpers._
import play.api.libs.ws.WS
import models._
import controllers._
import play.api.libs.json._
import play.api.libs.json.Json._
import rest.BaseSpec

class ServicesTest extends  BaseSpec {

  "All Clusters" in {
    running(TestServer(port)) {
      await(WS.url(s"$baseApi/clusters").get, timeout).body must equalTo(tempClusters.toString)
    }
  }

  "Cluster By Id" in {
    running(TestServer(port)) {
      await(WS.url(s"$baseApi/clusters/G0001").get, timeout).body must equalTo(((tempClusters \ "clusters")(0)).toString)
    }
  }  
  
  /*"Create new cluster" in {
    running(TestServer(port)) {
      await(WS.url(s"$baseApi/clusters/G0001").post(Map("newcluster" -> List(tempNewCluster))), timeout).body must equalTo(((tempClusters \ "clusters")(0)).toString)
    }
  }  */
  
  val base = "/api"
    
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
      ))
      
      val tempNewCluster = obj(
          "clusterId" -> "G0005",  
          "graph" -> arr(
              obj("element" -> "C0002",
                "relatedElements"-> arr("F0010","F0011"))             
          )
        )
  
}
