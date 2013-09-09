package rest

import play.api.test._
import play.api.test.Helpers._
import play.api.libs.ws.WS

class SolutionComponentWSFunctionalTest extends BaseSpec {

  "HTTP Response status" in {
    running(TestServer(port)) {
      await(WS.url(s"$baseApi/solutionComponents").get, timeout).status must equalTo(OK)
    }
  }

  "Content-type" in {
    running(TestServer(port)) {
      await(WS.url(s"$baseApi/solutionComponents").get, timeout).header("content-type").toString must contain("application/json")
    }
  }
}