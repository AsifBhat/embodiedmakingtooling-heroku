package app.models

import org.scalatest.FunSuite
import org.junit.runner.RunWith
import models.contents._



class ClusterSuite extends FunSuite {
  
  test("Empty Cluster creation") {
    intercept[IllegalArgumentException] {
      new Cluster("G01",List())
    }
  }
  
}
