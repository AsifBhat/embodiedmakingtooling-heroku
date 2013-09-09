package app.models.contents

import org.scalatest.FunSuite
import org.junit.runner.RunWith
import models.contents._
import org.scalatest.junit.JUnitRunner

@RunWith(classOf[JUnitRunner])
class ClusterTest extends FunSuite {
  val c = new Cluster("G0001", List(
    (Force.getElementById("F0005").get, Force.getElementById("F0006").get),
    (Force.getElementById("F0006").get, Force.getElementById("F0007").get),
    (Force.getElementById("F0007").get, Force.getElementById("F0003").get),
    (Force.getElementById("F0003").get, Force.getElementById("F0004").get),
    (Force.getElementById("F0004").get, Force.getElementById("F0008").get),
    (Force.getElementById("F0008").get, Force.getElementById("F0009").get)))

  test("Test graph creation") {
    assert(c != null)
  }

  test("Printing a cluster") {
    println(c)
  }

  test("Empty Cluster creation") {
    intercept[IllegalArgumentException] {
      new Cluster("G01", List())
    }
  }

  test("Presence of added nodes in cluster") {
    assert(c.contains(Force.getElementById("F0006").get) === true)
  }

  test("Absence of non-existent nodes in cluster") {
    assert(c.contains(Force.getElementById("F0001").get) === false)
  }

  test("Neighbours of a node") {
    assert(c.getNeighbours(Force.getElementById("F0003").get) === Set(Force.getElementById("F0007").get, Force.getElementById("F0004").get))
  }

  test("Neighbours of a non-existent node") {
    val neighbours = c.getNeighbours(Force.getElementById("F0001").get)
    assert(neighbours == Set())
  }


}
