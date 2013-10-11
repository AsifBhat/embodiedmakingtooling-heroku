package controllers

import play.api.mvc._
import play.api.libs.json._
import play.api.libs.json.Json._
import models.{Force, Story, SolutionComponent, ClusterEntity, PositionForHexGrid}
import play.api.libs.functional.syntax._
import play.api.libs.json.Reads._
import java.io._
import scala.util.matching.Regex
import scala.collection.mutable.ListBuffer

object Services extends Controller {
  val baseUrl = "/api"

  implicit val storyReader = reads[Story]
  implicit val storyWriter = writes[Story]
  implicit val forceReader = reads[Force]
  implicit val forceWriter = writes[Force]
  implicit val solutionComponentReader = reads[SolutionComponent]
  implicit val solutionComponentWriter = writes[SolutionComponent]
  implicit val complexreads: Reads[(String, List[String])] = (
    ((__ \ "element").read[String] and
      (__ \ "relatedElements").read[List[String]]
      tupled)
    )
  implicit val clusterEntityReader = reads[ClusterEntity]
  implicit val complexwrites: Writes[(String, List[String])] = (
    ((__ \ "element").write[String] and
      (__ \ "relatedElements").write[List[String]]
      tupled)
    )
  implicit val clusterEntityWriter = writes[ClusterEntity]


  def api = Action {
    Ok(prettyPrint(obj("links" -> arr(s"$baseUrl/clusters"))))
  }

  def clusters = Action {
    val clusters = ClusterEntity.allClusters
    Ok(toJson(obj("clusters" -> clusters)))
  }

  def cluster(id: String) = Action {
    Ok(toJson(ClusterEntity.getClusterById(id)))
  }

  def stories = Action {
    Ok(toJson(Story.all()))
  }

  def story(id: String) = Action {
    Ok(toJson(Story.getElementById(id)))
  }

  def forces = Action {
    Ok(toJson(Force.all()))
  }

  def force(id: String) = Action {
    Ok(toJson(Force.getElementById(id)))
  }

  def solutionComponents = Action {
    Ok(toJson(SolutionComponent.all()))
  }

  def solutionComponent(id: String) = Action {
    Ok(toJson(SolutionComponent.getElementById(id)))
  }

  def createCluster = Action {
    request =>
      val clusterWithoutIdJson = request.body.asJson.get
      val res: JsResult[ClusterEntity] = clusterWithoutIdJson.validate(clusterEntityReader)
      val clusterWithoutId = res.get
      val clusterWithId = ClusterEntity.addClusterToMem(clusterWithoutId)
      Created(toJson(clusterWithId))
  }

  def updateCluster(id: String) = Action {
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
  }

  def importFile = Action(parse.temporaryFile) { request =>    
    val tempFile = File.createTempFile("temp_upload", null)
    request.body.moveTo(tempFile, true)
    val reader = scala.io.Source.fromFile(tempFile.getCanonicalFile())
    val lineItr = reader.getLines()
    val pattern = new Regex("(?i)([CSF]\\d+)\\.?\\s+(.+)")
    val newStrs = ListBuffer[Story]()
    val newFrcs = ListBuffer[Force]()
    val newScs = ListBuffer[SolutionComponent]()
    
    while(lineItr.hasNext){
      pattern.findAllIn(lineItr.next).matchData foreach {
        m => {
          var grpChar: Char = m.subgroups(0).toLowerCase().charAt(0)
          if (grpChar == 'c') newScs +=(SolutionComponent(m.subgroups(0), m.subgroups(1)))
          else if(grpChar == 's' ) newStrs +=(Story(m.subgroups(0), m.subgroups(1)))
          else if(grpChar == 'f') newFrcs +=(Force(m.subgroups(0), m.subgroups(1)))
        }
      }
    }
    reader.close
    Force.allForces = newFrcs.toList
    Story.allStories = newStrs.toList
    SolutionComponent.allSolutionComponents = newScs.toList
    ClusterEntity.allClusters = List[ClusterEntity]() 
    PositionForHexGrid.allPos = List[PositionForHexGrid]()
    Ok("<b>Import Complete:</b> " +
    		"<br>Forces: " + newFrcs.size + 
    		"<br>Stories: " + newStrs.size + 
    		"<br>SolutionComponents: "+ newScs.size)
  }
}
