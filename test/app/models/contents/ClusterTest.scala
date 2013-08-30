package app.models.contents

import org.scalatest.FunSuite
import org.junit.runner.RunWith
import models.contents._
import org.scalatest.junit.JUnitRunner

@RunWith(classOf[JUnitRunner])
class ClusterSuite extends FunSuite {
	val c = new Cluster("G0001",List((Force.getElementById("F0005"),Force.getElementById("F0006")),
			(Force.getElementById("F0006"),Force.getElementById("F0007")),
			(Force.getElementById("F0007"),Force.getElementById("F0003")),
			(Force.getElementById("F0003"),Force.getElementById("F0004")),
			(Force.getElementById("F0004"),Force.getElementById("F0008")),
			(Force.getElementById("F0008"),Force.getElementById("F0009"))))		
  
	test("Test graph creation"){
	  assert(c != null)	 
	}
  
	test("Printing a cluster"){
		println(c)
	}
  
	test("Empty Cluster creation") {
		intercept[IllegalArgumentException] {
			new Cluster("G01",List())
		}
	}
  
	test("Presence of added nodes in cluster") {
		assert(c.contains(Force.getElementById("F0006")) === true)
	}
	
	test("Absence of non-existent nodes in cluster") {
		assert(c.contains(Force.getElementById("F0001")) === false)
	}
	
	test("Neighbours of a node"){
	  assert(c.getNeighbours(Force.getElementById("F0003")) === Set(Force.getElementById("F0007"),Force.getElementById("F0004")))
	}	
	
	test("Neighbours of a non-existent node"){
	  intercept[Error] {
		  val neighbours = c.getNeighbours(Force.getElementById("F0001"))
    }
}  
}
