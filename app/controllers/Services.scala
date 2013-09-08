package controllers

import play.api.mvc._
import play.api.libs.json.Json
import models.contents.{SolutionComponent, Force, Story}

object Services extends Controller {

  def stories = Action {
    implicit val reader = Json.reads[Story]
    implicit val writer = Json.writes[Story]
    Ok(Json.toJson(Story.all()))
  }

  def forces = Action {
    implicit val reader = Json.reads[Force]
    implicit val writer = Json.writes[Force]
    Ok(Json.toJson(Force.all()))
  }

  def solutionComponents = Action {
    implicit val reader = Json.reads[SolutionComponent]
    implicit val writer = Json.writes[SolutionComponent]
    Ok(Json.toJson(SolutionComponent.all()))
  }
}
