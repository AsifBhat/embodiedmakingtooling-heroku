package controllers

import play.api._
import play.api.mvc._
import models._
import views._


object Application extends Controller {
  
  def index = Action {
    Ok(views.html.index("The Embodied Making Tool",Story.all(),Force.all(),ForceInteraction.all(),SolutionComponent.all()))
  }

  def worksheet = Action {
    Ok(views.html.worksheet("The Embodied Making Tool",Story.all(),Force.all(),ForceInteraction.all(),SolutionComponent.all()))
  }
  
}