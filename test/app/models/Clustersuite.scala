package app.models

import org.scalatest.FunSuite
import org.junit.runner.RunWith
import models.contents._
import org.scalatest.junit.JUnitRunner

@RunWith(classOf[JUnitRunner])
class ClusterSuite extends FunSuite {
  
  test("Test graph creation"){
	  val c = new Cluster("G0001",List("F0005->F0006","F0006->F0007","F0007->F0003","F0003->F0004","F0004->F0008","F0008->F0009"))
	  val isPresent1 = c.contains("F0005")
	  val isPresent2 = c.contains("F0001")
	  assert(c != null)
	  assert(isPresent1 === true)
	  assert(isPresent2 === false)
  }
  
  test("Printing a cluster"){
    val c = new Cluster("G0001",List("F0005->F0006","F0006->F0007","F0007->F0003","F0003->F0004","F0004->F0008","F0008->F0009"))
    println(c)
  }
  
  test("Empty Cluster creation") {
    intercept[IllegalArgumentException] {
      new Cluster("G01",List())
    }
  }
  
  
}
