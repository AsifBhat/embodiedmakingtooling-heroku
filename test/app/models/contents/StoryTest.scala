package app.models.contents

import org.scalatest.FunSuite
import org.junit.runner.RunWith
import models.contents._
import org.scalatest.junit.JUnitRunner


@RunWith(classOf[JUnitRunner])
class StoryTest extends FunSuite {
  test("Testing Story Element for equality if ID and Description are the same: Should pass ") {
    val story1 = new Story("S0001", "We share 10 meeting rooms, usually named after people to identify them, between 300 people, and the meeting rooms need to be kept locked.")
    val story2 = new Story("S0001", "We share 10 meeting rooms, usually named after people to identify them, between 300 people, and the meeting rooms need to be kept locked.")
    
    assert(story1 == story2)
  }
  
  test("Testing Story Element for Inequality if IDs are different for two Story Objects: Should Pass "){
    val story1 = new Story("S0001", "We share 10 meeting rooms, usually named after people to identify them, between 300 people, and the meeting rooms need to be kept locked.")
    val story2 = new Story("S0003","We share 10 meeting rooms, usually named after people to identify them, between 300 people, and the meeting rooms need to be kept locked.")
    
    assert(story1 != story2)
  }
  
  test("Testing Story Element for Inequality if Descriptions are different: Should Pass "){
    val story1 = new Story("S0001", "We share 10 meeting rooms, usually named after people to identify them, between 300 people, and the meeting rooms need to be kept locked.")
    val story2 = new Story("S0001","I often have back-to-back meetings, and I don't always have time to return the key.")
    
    assert(story1 != story2)
  }
  
  test("Testing Story Element for Inequality for different IDs and Descriptions: Should Pass"){
    val story1 = new Story("S0001", "We share 10 meeting rooms, usually named after people to identify them, between 300 people, and the meeting rooms need to be kept locked.")
    val story2 = new Story("S0002","I often have back-to-back meetings, and I don't always have time to return the key.")

    assert(story1 != story2)
  }
  
  test("Testing Story Element for null description: Should Fail") {
    val story1 = new Story("S0001", "")
    assert(story1 != null)
  }
}