package app.models

import org.scalatest.FunSuite
import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import models._

@RunWith(classOf[JUnitRunner])
class ClusterEntityTest extends FunSuite {
  val c = new Cluster("G0002", List(
        		(Story.getElementById("S0004").get, Force.getElementById("F0010").get),
        		(Story.getElementById("S0004").get, Force.getElementById("F0011").get),
        		(Force.getElementById("F0010").get, Force.getElementById("F0011").get)))
  
  
  test("Test cluster creation") {
    assert(c != null)
    val ce = new ClusterEntity("",
        List(("S0004",List("F0010","F0011")),
            ("F0010",List("F0011"))
            )
        )
  }

 
}
