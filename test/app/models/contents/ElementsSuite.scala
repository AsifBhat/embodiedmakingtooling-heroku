package models

import org.scalatest.FunSuite
import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import models.contents._
import junit.framework.{TestCase} 


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
    assert(story1 === story2)
    assert(force1 === force2)
    assert(component1 === component2)
    assert(story3!=story2)
  }
}
