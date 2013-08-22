package models.contents

import play.api.libs.json._
import play.api.libs.functional.syntax._  

case class Story (id:String,description:String) extends ContentElement {
  require(description.length()>0, "The description must not be empty")
}
                   
object Story {
  
  def all(): List[Story] = {
		List(new Story("S0001","We share 10 meeting rooms, usually named after people to identify them, between 300 people, and the meeting rooms need to be kept locked."),
		    new Story("S0002","The receptionist helps book the room, and room users pick up the key, and usually drop it back."),
		    new Story("S0003","Although people are supposed to pick up and drop off the key with me, they rarely do. I have to run around and try and trace where the keys are."),
		    new Story("S0004","I often have back-to-back meetings, and I don’t always have time to return the key."),
		    new Story("S0005","We lose keys to meeting rooms all the time and have to replace all the locks 3 or 4 times a year."),
		    new Story("S0006","We need presentation equipment for meetings."))
  }

	implicit val reader = Json.reads[Story]
	implicit val writer = Json.writes[Story] 

}                   
                   
