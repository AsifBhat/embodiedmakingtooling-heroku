package rest

import play.api.test._
import play.api.test.Helpers._
import play.api.libs.ws.WS

class ForceWSFunctionalTest extends BaseSpec {

  "HTTP Response status" in {
    running(TestServer(port)) {
      await(WS.url(s"$baseApi/forces").get, timeout).status must equalTo(OK)
    }
  }

  "Content type" in {
    running(TestServer(port)) {
      await(WS.url(s"$baseApi/forces").get, timeout).header("content-type").toString must contain("application/json")
    }
  }
}