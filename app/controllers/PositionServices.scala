package controllers

import play.api.mvc._
import play.api.libs.json._
import play.api.libs.json.Json._
import play.api.libs.functional.syntax._
import play.api.libs.json.Reads._
import models.PositionForHexGrid
import play.data.DynamicForm

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
 
  def updatePos(clusterIdToDel: String) = Action {
    request =>
      val clusterIdToKeep = request.body.asJson.get.as[String]
      val allPositions = PositionForHexGrid.all
      PositionForHexGrid.allPos = allPositions.map(pos => 
        if (pos.clusterId == clusterIdToDel) 
          new PositionForHexGrid(pos.posId,pos.elementId,clusterIdToKeep, pos.xPos, pos.yPos) 
        else pos)

      Ok(toJson(new PositionForHexGrid("","","",0,0)))
  }

  /*def deleteCluster(id: String) = Action {
    ClusterEntity.allClusters = ClusterEntity.all.filter(cluster => cluster.id != id)
    Ok(id)
  }*/
}
