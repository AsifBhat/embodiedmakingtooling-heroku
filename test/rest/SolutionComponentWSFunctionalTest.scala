package rest

import org.specs2.mutable._
import play.api.test._
import play.api.test.Helpers._
import play.api.libs.ws.WS
import scala.concurrent.duration._
import java.util.concurrent.TimeUnit

class SolutionComponentWSFunctionalTest extends Specification {

  "run in a server: Checking for HTTP Response status" in {
    running(TestServer(3333)) {

      await(WS.url("http://localhost:3333/SolutionComponents").get, 5000).status must equalTo(OK)

    }
  }
  "run in a server: Testing for content-type" in {
    running(TestServer(3333)) {
      await(WS.url("http://localhost:3333/SolutionComponents").get, 5000).header("content-type").toString must contain("application/json")
    }
  }
}