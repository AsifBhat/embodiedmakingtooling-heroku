package app.models.contents

import org.scalatest.FunSuite

class StoryTest extends FunSuite {

  test("Test Story") {
    val Story = Story("01", "This is a test Story")
    assert(diff === 3)
  }
}
