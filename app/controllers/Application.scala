package controllers

import play.api._
import play.api.mvc._
import models._
import views._
import play.api.libs.functional.syntax._
import play.api.libs.json._

object Application extends Controller {
  
  private var jsonClusters = Json.toJson(Cluster.all)  
  
  def worksheet = Action {
    Ok(views.html.worksheet("The Embodied Making Tool",ContentElement.all(),Cluster.all()))
  }
  
  def clustering = Action {
    Ok(views.html.clustering.render())    
  }
  
  def allContentElements = Action {
    val jsonce = Json.toJson(ContentElement.all)
    Ok(jsonce)
  }
  
  def allClusters = Action {
     Ok(jsonClusters)
  }
  
 /* def saveClusters = Action { implicit request =>
   	val newClusters = (Json.parse(request.body.asText.get).as[Cluster])
   	//jsonClusters.
   	Ok(jsonClusters)
  }*/
  
}