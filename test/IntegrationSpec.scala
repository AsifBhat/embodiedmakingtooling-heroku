package test

import org.specs2.mutable._

import play.api.test._
import play.api.test.Helpers._
import play.api.libs.ws.WS

/**
 * add your integration spec here.
 * An integration test will fire up a whole play application in a real (or headless) browser
 */
class IntegrationSpec extends Specification {
  
  "Application" should {
    
    /*"work from within a browser" in {
      running(TestServer(3344), HTMLUNIT) { browser =>

        browser.goTo("http://localhost:3344")

        browser.pageSource must contain("Embodied")
       
      }
    }*/
    "run in a server" in new WithServer {
		  await(WS.url("http://localhost:" + port).get).status must equalTo(OK)
	}
    
  }
  
}