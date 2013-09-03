package models.contents

import play.api.libs.json._
import play.api.libs.functional.syntax._

case class SolutionComponent (_id:String,description:String) extends ContentElement (_id,description)
  
object SolutionComponent{
  type SC = SolutionComponent
  def all ():List[SC]={
    List(
    	new SC("C0001","Use large animal plush toys as keychains, a distinct one for each room."),
    	new SC("C0002","Keep \"animals\" in a play pen in the reception."),
    	new SC("C0003","Has anyone seen the water buffalo."),
    	new SC("C0004","Name rooms after animals."),
    	new SC("C0005","Bring \"animals\" back to their pen."),
    	new SC("C0006","Play \"who's got the animal\" before and after meetings."),
    	new SC("C0007","Create an animal themed cafe for small groups to meet.")
    )
  }
  
  def getElementById(id:String):SolutionComponent = getElementById(id,all())
	
	def getElementById(id:String , solutions:List[SolutionComponent]): SolutionComponent={
	  if(solutions.head.id==id) solutions.head
	  else (getElementById(id,solutions.tail))
	}

  implicit val reader = Json.reads[SC]
  implicit val writer = Json.writes[SC] 
}  
                  
