package controllers

import play.api.mvc._
import services.ExportGexf

object Utilities extends Controller {
  
  def exportAsGexf(fileName: String) = Action {
    ExportGexf.export("public/exports/clusters.gexf")
    Ok("Exported")
  }  
}