package app.models.contents

import org.scalatest.FunSuite
import org.junit.runner.RunWith
import models.contents._
import org.scalatest.junit.JUnitRunner

@RunWith(classOf[JUnitRunner])
class SolutionComponentTest  extends FunSuite {

  test("Testing Solution Component Element for equality if ID and Description are the same: Should Pass ") {
    val solutionComponent1 = new SolutionComponent("SC001", "Distinct and large keychains using a common theme")
    val solutionComponent2 = new SolutionComponent("SC001", "Distinct and large keychains using a common theme")

    assert(solutionComponent1 == solutionComponent2)
  }

  test("Testing Solution Component Element for Inequality if IDs are different for two Solution Component Objects: Should Pass ") {
    val solutionComponent1 = new SolutionComponent("SC001", "Distinct and large keychains using a common theme")
    val solutionComponent2 = new SolutionComponent("SC002", "Distinct and large keychains using a common theme")

    assert(solutionComponent1 != solutionComponent2)
  }

  test("Testing Solution Component Element for Inequality if Descriptions are different: Should Pass ") {
    val solutionComponent1 = new SolutionComponent("SC001", "Distinct and large keychains using a common theme")
    val solutionComponent2 = new SolutionComponent("SC001", "Common Area with several small tables with 3 to 4 seats")

    assert(solutionComponent1 != solutionComponent2)
  }

  test("Testing Solution Component Element for Inequality for different IDs and Descriptions: Should Pass") {
    val solutionComponent1 = new SolutionComponent("SC001", "Distinct and large keychains using a common theme")
    val solutionComponent2 = new SolutionComponent("SC002", "Common Area with several small tables with 3 to 4 seats")

    assert(solutionComponent1 != solutionComponent2)
  }
  
  test("Testing Solution Component Element for null description: Should Pass") {
    intercept[IllegalArgumentException] {
      val solutionComponent1 = new SolutionComponent("SC001", "")
    }
  }

}