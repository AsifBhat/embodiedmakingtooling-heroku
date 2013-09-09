package rest

import play.api.test._
import play.api.test.Helpers._
import play.api.libs.ws.WS

class StoryWSFunctionalTest extends BaseSpec {

  "HTTP response status" in {
    running(TestServer(port)) {
      await(WS.url(s"$baseApi/stories").get, timeout).status must equalTo(OK)
    }
  }

  "Content type" in {
    running(TestServer(port)) {
      await(WS.url(s"$baseApi/stories").get, timeout).header("content-type").toString must contain("application/json")
    }
  }
}