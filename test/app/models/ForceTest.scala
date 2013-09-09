package app.models

import org.scalatest.FunSuite
import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import models.Force

@RunWith(classOf[JUnitRunner])
class ForceTest extends FunSuite {

  test("Equality if ID and Description are the same") {
    val force1 = new Force("F0001", "Meeting rooms are shared by a lot of people.")
    val force2 = new Force("F0001", "Meeting rooms are shared by a lot of people.")

    assert(force1 == force2)
  }

  test("Inequality if IDs are different for two Force Objects") {
    val force1 = new Force("F0001", "Meeting rooms are shared by a lot of people.")
    val force2 = new Force("F0002", "Meeting rooms are shared by a lot of people.")

    assert(force1 != force2)
  }

  test("Inequality if Descriptions are different") {
    val force1 = new Force("F0001", "Meeting rooms are shared by a lot of people.")
    val force2 = new Force("F0001", "Meeting rooms contain expensive equipment.")

    assert(force1 != force2)
  }

  test("Inequality for different IDs and Descriptions") {
    val force1 = new Force("F0001", "Meeting rooms are shared by a lot of people.")
    val force2 = new Force("F0002", "Meeting rooms contain expensive equipment.")

    assert(force1 != force2)
  }

  test("Empty description") {
    new Force("F0001", "")
  }
}