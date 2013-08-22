package app.models

import org.scalatest.FunSuite
import org.junit.runner.RunWith
import models.contents._
import org.scalatest.junit.JUnitRunner


@RunWith(classOf[JUnitRunner])
class ElementsSuite extends FunSuite {
  
  //@Test
  test("Equality tests"){
    val story1 = new Story("S0001","We share 10 meeting rooms, usually named after people to identify them, between 300 people, and the meeting rooms need to be kept locked.")
    val story2 = new Story("S0001","We share 10 meeting rooms, usually named after people to identify them, between 300 people, and the meeting rooms need to be kept locked.")
    val story3 = new Story("S0003","We share 10 meeting rooms, usually named after people to identify them, between 300 people, and the meeting rooms need to be kept locked.")
    val force1 = new Force("F0001","Meeting rooms are shared by a lot of people.")
    val force2 = new Force("F0001","Meeting rooms are shared by a lot of people.")
    val component1 = new SolutionComponent("C0004","Name rooms after animals.")
    val component2 = new SolutionComponent("C0004","Name rooms after animals.")
    val story4 = new Story("S0003","I often have back-to-back meetings, and I don’t always have time to return the key.")
    assert(story1 === story2)
    assert(force1 === force2)
    assert(component1 === component2)
    assert(story3!=story2)
    assert(story3 != story4)
  }
  
  test("Empty Content Elements") {
    intercept[IllegalArgumentException] {
      new Story("S01","")
    }
    intercept[IllegalArgumentException] {
      new Force("F01","")
    }
    intercept[IllegalArgumentException] {
      new SolutionComponent("C01","")
    }
  }
  
}
