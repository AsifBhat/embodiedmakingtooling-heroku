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
  
}