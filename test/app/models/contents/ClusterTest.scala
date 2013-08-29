package app.models.contents

import org.scalatest.FunSuite
import org.junit.runner.RunWith
import models.contents._
import org.scalatest.junit.JUnitRunner

@RunWith(classOf[JUnitRunner])
class ClusterSuite extends FunSuite {
  
  test("Test graph creation"){
	  val c = new Cluster("G0001",List((Force.getElementById("F0005"),Force.getElementById("F0006")),
			(Force.getElementById("F0006"),Force.getElementById("F0007")),
			(Force.getElementById("F0007"),Force.getElementById("F0003")),
			(Force.getElementById("F0003"),Force.getElementById("F0004")),
			(Force.getElementById("F0004"),Force.getElementById("F0008")),
			(Force.getElementById("F0008"),Force.getElementById("F0009"))))		 
	  assert(c != null)	 
  }
  
  test("Printing a cluster"){
     val c = new Cluster("G0001",List((Force.getElementById("F0005"),Force.getElementById("F0006")),
			(Force.getElementById("F0006"),Force.getElementById("F0007")),
			(Force.getElementById("F0007"),Force.getElementById("F0003")),
			(Force.getElementById("F0003"),Force.getElementById("F0004")),
			(Force.getElementById("F0004"),Force.getElementById("F0008")),
			(Force.getElementById("F0008"),Force.getElementById("F0009"))))	
    println(c)
  }
  
  test("Testing Cluster for edge.."){
    val c = new Cluster("G0001",List((Force.getElementById("F0005"),Force.getElementById("F0006"))))
    
  }
  
  test("Empty Cluster creation") {
    intercept[IllegalArgumentException] {
      new Cluster("G01",List())
    }
  }
  
}
