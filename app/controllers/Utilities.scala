package controllers

import play.api.mvc._
import services.ExportGexf

object Utilities extends Controller {

  def exportAsGexf = Action {
    Ok(ExportGexf.export).withHeaders("Content-Disposition" -> "attachment; filename=clusters.gexf")
  }
}