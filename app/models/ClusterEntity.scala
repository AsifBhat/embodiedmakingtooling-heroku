package models

import play.api.libs.json._
import play.api.libs.functional.syntax._

case class ClusterEntity(id:String, relations: List[(String, List[String])]){
  
  private var graphRelations: List[(ContentElement,ContentElement)] = getGraphRelations
  
  private var cluster = if(graphRelations.length==0) {
    val rootelem = getContentElement(relations(0)._1)
    new Cluster(id,List((rootelem,rootelem)))
  }
  else new Cluster(id,graphRelations)
  
  
  def getGraphRelations : List[(ContentElement,ContentElement)] = {
    relations.map(rel => rel._2.map(dest => (getContentElement(rel._1) ,getContentElement(rel._1)))).flatten
  }
  
  private def getContentElement(id:String):ContentElement ={
    val contentElementType = id.subSequence(0, 1)
    val element = contentElementType match {
    	case "F" => Force.getElementById(id).get
    	case "S" => Story.getElementById(id).get
    	case "C" => SolutionComponent.getElementById(id).get
    }
    element
  }
  
  override def toString() = {
    val prnid = "Cluster ID: "+id+"\n"
    val prnrel = relations.map(rel => rel._1 +" -> "+ rel._2)
    prnid+prnrel
  }
  
  
}

