package rest

import org.specs2.mutable._
import play.api.test._
import play.api.test.Helpers._
import play.api.libs.ws.WS
import scala.concurrent.duration._
import java.util.concurrent.TimeUnit

/**
 * add your integration spec here.
 * An integration test will fire up a whole play application in a real (or headless) browser
 */
class ForceWSFunctionalTest extends Specification {

  "run in a server: Checking for HTTP Response status" in {
    running(TestServer(3333)) {

      await(WS.url("http://localhost:9000/Forces").get, 5000).status must equalTo(OK)

    }
  }
  "run in a server: Testing for content type" in {
    running(TestServer(3333)) {
      await(WS.url("http://localhost:9000/Forces").get, 5000).header("content-type").toString must contain("application/json")
    }
  }
}