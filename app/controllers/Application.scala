package controllers

import play.api.mvc._
import play.api.libs.json._
import models.contents.Story
import models.contents.SolutionComponent
import models.contents.Force

object Application extends Controller {
  
  def index = Action {
    Ok(views.html.index())
  }  
 
  def stories = Action {
    val jsonStories = Json.toJson(Story.all())
    Ok(jsonStories)
  }

  def forces = Action {
    val jsonForces = Json.toJson(Force.all())
    Ok(jsonForces)
  }

  def solutionComponents = Action {
    val jsonComponents = Json.toJson(SolutionComponent.all())
    Ok(jsonComponents)
  }    
}