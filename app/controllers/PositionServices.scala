package controllers

import play.api.mvc._
import play.api.libs.json._
import play.api.libs.json.Json._
import play.api.libs.functional.syntax._
import play.api.libs.json.Reads._
import models.PositionForHexGrid

object PositionServices extends Controller {
  
  implicit val posWriter = writes[PositionForHexGrid]
  implicit val posReader = reads[PositionForHexGrid]
 
  def allPos = Action {
    Ok(toJson(PositionForHexGrid.all()))
  }

  def createPos = Action {
    request =>
      val posJson = request.body.asJson.get
      val pos = posJson.as[PositionForHexGrid]
      val createdpos = PositionForHexGrid.addPosToMem(pos)
      Created(toJson(createdpos))
  }

 /* def updateCluster(id: String) = Action {
    request =>
      val updatedClusterObject = request.body.asJson.get
      val res: JsResult[ClusterEntity] = updatedClusterObject.validate(clusterEntityReader)
      val listOfClusters = ClusterEntity.all
      val updatedCluster = new ClusterEntity(res.get.id, res.get.relations.sortBy(r => 0 - r._2.length))
      ClusterEntity.allClusters = listOfClusters.map(cluster => if (cluster.id == id) updatedCluster else cluster)

      Ok(toJson(id))
  }

  def deleteCluster(id: String) = Action {
    ClusterEntity.allClusters = ClusterEntity.all.filter(cluster => cluster.id != id)
    Ok(id)
  }*/
}
