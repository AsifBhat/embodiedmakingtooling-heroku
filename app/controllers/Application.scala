package controllers

import play.api.mvc._
import play.api.libs.json._
import models.contents.Story
import models.contents.SolutionComponent
import models.contents.Force

object Application extends Controller {
  
  //private var jsonClusters = Json.toJson(Cluster.all)  
 /* 
  def worksheet = Action {
    Ok(views.html.worksheet("The Embodied Making Tool",Story.all(),Force.all(),SolutionComponent.all(),Cluster.all()))
  }*/
  
  def svgworksheet = Action {
    Ok(views.html.svgworksheet("The Embodied Making Tool"))
  }
  
  def createJS = Action {
    Ok(views.html.createjs())
  }

  def clustering = Action {
    Ok(views.html.clustering.render())    
  }
  
  def allStories = Action {
    val jsonStories = Json.toJson(Story.all())
    Ok(jsonStories)
  }

  def allForces = Action {
    val jsonForces = Json.toJson(Force.all())
    Ok(jsonForces)
  }

  def allSolutionComponents = Action {
    val jsonComponents = Json.toJson(SolutionComponent.all())
    Ok(jsonComponents)
  }    
  
  def allClusters = Action {
     Ok("jsonClusters")
  }
  
 /* def saveClusters = Action { implicit request =>
   	val newClusters = (Json.parse(request.body.asText.get).as[Cluster])
   	//jsonClusters.
   	Ok(jsonClusters)
  }*/
  
}