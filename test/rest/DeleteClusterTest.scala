package rest

import play.api.test._
import play.api.test.Helpers._
import play.api.libs.ws.WS
import models.ClusterEntity

class DeleteClusterTest extends BaseSpec {
  "HTTP response status for delete cluster request " in {
    running(TestServer(port)) {
      var clusterID = ClusterEntity.all.last.id
      await(WS.url(s"$baseApi/clusters/" + clusterID).delete, timeout).status must equalTo(OK)
    }
  }
  
  "HTTP Request for delete cluster request " in {
    running(TestServer(port)){
      var cluster = ClusterEntity.all.last
      await(WS.url(s"$baseApi/clusters/" + cluster.id).delete, timeout)
      
      ClusterEntity.all.find(cl => if (cl.id == cluster.id) true else false) must equalTo(None)
      
    }
  }
}