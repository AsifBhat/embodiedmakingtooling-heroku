package app.models

import org.scalatest.FunSuite
import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import models._
import play.api.libs.json._
import play.api.libs.json.Json._

@RunWith(classOf[JUnitRunner])
class ClusterEntityTest extends FunSuite {
  
  test("Test cluster creation") {
    val ce = new ClusterEntity("G0001",
        List(("S0004",List("F0010","F0011")),
            ("F0010",List("F0011"))
            )
        )
    assert(ce!=null)
  }
  
  test("New Cluster creation"){
    val newcluster = new ClusterEntity("G0001",List(("S0004",List())))
    assert(newcluster!=null)
  }
  
  test("Add new cluster to memory"){
    val oldLength = ClusterEntity.all.length
    val newcluster = new ClusterEntity("G0001",List(("S0004",List())))
    val clusterWithId = ClusterEntity.addClusterToMem(newcluster)
    val newLength = ClusterEntity.all.length
    assert(oldLength == newLength-1)
  }
}
