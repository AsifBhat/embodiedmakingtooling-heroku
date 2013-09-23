package app.models

import org.scalatest.FunSuite
import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import models._
import play.api.libs.json._
import play.api.libs.json.Json._

@RunWith(classOf[JUnitRunner])
class ClusterEntityTest extends FunSuite {
  val c = new Cluster("G0002", List(
        		(Story.getElementById("S0004").get, Force.getElementById("F0010").get),
        		(Story.getElementById("S0004").get, Force.getElementById("F0011").get),
        		(Force.getElementById("F0010").get, Force.getElementById("F0011").get)))
  
  
  test("Test cluster creation") {
    val ce = new ClusterEntity("G0001",
        List(("S0004",List("F0010","F0011")),
            ("F0010",List("F0011"))
            )
        )
    println(ce)
    assert(ce!=null)
  }
  
  test("New Cluster creation"){
    val newcluster = new ClusterEntity("G0001",List(("S0004",List())))
    assert(newcluster!=null)
  }
  
  
  
  /*test("Cluster deserialization" {
	  val temp = obj(
          "clusterId" -> "G0005",  
          "graph" -> arr(
              obj("element" -> "S0004",
                "relatedElements"-> arr("F0010","F0011","F0012"))             
          )
        )
    temp.validate[ClusterEntity].fold(
    valid = ( res => Ok(res.name) ),
    invalid = ( e => BadRequest(e.toString) )
  )
  }*/

 
}
