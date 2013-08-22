package app.models.contents

import org.scalatest.FunSuite
import org.junit.runner.RunWith
import models.contents._
import org.scalatest.junit.JUnitRunner

@RunWith(classOf[JUnitRunner])
class ForceTest extends FunSuite {

  test("Testing Force Element for equality if ID and Description are the same: Should Pass ") {
    val force1 = new Force("F0001", "Meeting rooms are shared by a lot of people.")
    val force2 = new Force("F0001", "Meeting rooms are shared by a lot of people.")

    assert(force1 == force2)
  }

  test("Testing Force Element for Inequality if IDs are different for two Force Objects: Should Pass ") {
    val force1 = new Force("F0001", "Meeting rooms are shared by a lot of people.")
    val force2 = new Force("F0002", "Meeting rooms are shared by a lot of people.")

    assert(force1 != force2)
  }

  test("Testing Force Element for Inequality if Descriptions are different: Should Pass ") {
    val force1 = new Force("F0001", "Meeting rooms are shared by a lot of people.")
    val force2 = new Force("F0001", "Meeting rooms contain expensive equipment.")

    assert(force1 != force2)
  }

  test("Testing Force Element for Inequality for different IDs and Descriptions: Should Pass") {
    val force1 = new Force("F0001", "Meeting rooms are shared by a lot of people.")
    val force2 = new Force("F0002", "Meeting rooms contain expensive equipment.")

    assert(force1 != force2)
  }

}