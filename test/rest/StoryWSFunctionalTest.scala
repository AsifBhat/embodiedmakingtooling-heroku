package rest

import org.specs2.mutable._
import play.api.test._
import play.api.test.Helpers._
import play.api.libs.ws.WS
import scala.concurrent.duration._
import java.util.concurrent.TimeUnit

class StoryWSFunctionalTest extends Specification {

  "run in a server: Testing for Existence of WS" in {
    running(TestServer(3333)) {

      await(WS.url("http://localhost:9000/Stories").get, 5000).status must equalTo(OK)

    }
  }
  
  "run in a server: Testing for content type" in {
    running(TestServer(3333)) {

      await(WS.url("http://localhost:9000/Stories").get, 5000).header("content-type").toString must contain("application/json")

    }
  }  
}