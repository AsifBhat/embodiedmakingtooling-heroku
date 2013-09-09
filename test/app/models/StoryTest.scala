package app.models

import org.scalatest.FunSuite
import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import models.Story


@RunWith(classOf[JUnitRunner])
class StoryTest extends FunSuite {
  test("equality if ID and Description are the same") {
    val story1 = new Story("S0001", "We share 10 meeting rooms, usually named after people to identify them, between 300 people, and the meeting rooms need to be kept locked.")
    val story2 = new Story("S0001", "We share 10 meeting rooms, usually named after people to identify them, between 300 people, and the meeting rooms need to be kept locked.")

    assert(story1 == story2)
  }

  test("Inequality if IDs are different for two Story Objects") {
    val story1 = new Story("S0001", "We share 10 meeting rooms, usually named after people to identify them, between 300 people, and the meeting rooms need to be kept locked.")
    val story2 = new Story("S0003", "We share 10 meeting rooms, usually named after people to identify them, between 300 people, and the meeting rooms need to be kept locked.")

    assert(story1 != story2)
  }

  test("Inequality if Descriptions are different") {
    val story1 = new Story("S0001", "We share 10 meeting rooms, usually named after people to identify them, between 300 people, and the meeting rooms need to be kept locked.")
    val story2 = new Story("S0001", "I often have back-to-back meetings, and I don't always have time to return the key.")

    assert(story1 != story2)
  }

  test("Inequality for different IDs and Descriptions") {
    val story1 = new Story("S0001", "We share 10 meeting rooms, usually named after people to identify them, between 300 people, and the meeting rooms need to be kept locked.")
    val story2 = new Story("S0002", "I often have back-to-back meetings, and I don't always have time to return the key.")

    assert(story1 != story2)
  }

  test("Empty description") {
    new Story("S0001", "")
  }
}