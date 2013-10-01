package rest

import play.api.test._
import play.api.test.Helpers._
import play.api.libs.ws.WS

class CreateClusterTest extends BaseSpec {

    "HTTP response status for create cluster request " in {
    running(TestServer(port)) {
      var jsonData = "    { \"id\":\"G10\"," +
      		"\"relations\":[" +
      		"{\"element\":\"C0001\",\"relatedElements\":[\"F0001\",\"F0006\",\"F0011\",\"F0012\"]}," +
      		"{\"element\":\"F0005\",\"relatedElements\":[\"F0006\",\"F0004\",\"F0007\"]}," +
      		"{\"element\":\"F0006\",\"relatedElements\":[\"F0007\",\"F0013\"]}," +
      		"{\"element\":\"F0004\",\"relatedElements\":[\"F0007\"]}," +
      		"{\"element\":\"F0007\",\"relatedElements\":[\"F0013\"]}," +
      		"{\"element\":\"F0012\",\"relatedElements\":[\"F0011\"]}] }";
      await(WS.url(s"$baseApi/clusters").withHeaders("Content-Type" -> "application/json").post(jsonData), timeout).status must equalTo(CREATED)
    }
  }
}