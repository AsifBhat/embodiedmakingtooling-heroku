package controllers

import play.api._
import play.api.mvc._
import models._
import views._


object Application extends Controller {
  
  def worksheet = Action {
    Ok(views.html.worksheet("The Embodied Making Tool",Story.all(),Force.all(),ForceInteraction.all(),SolutionComponent.all()))
  }
  
}