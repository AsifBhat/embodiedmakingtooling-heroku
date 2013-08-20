package models.contents

import play.api.libs.json._
import play.api.libs.functional.syntax._

case class Force (id:String,description:String) extends ContentElement 
                   
object Force {
  
	def all(): List[Force] = {
		List(new Force("F0001","Meeting rooms are shared by a lot of people."),
		    new Force("F0002","Meeting rooms contain expensive equipment."),
		    new Force("F0003","Desire to protect equipment in meeting rooms."),
		    new Force("F0004","Limited number of meeting rooms."),
		    new Force("F0005","Meeting rooms are booked with a single point."),
		    new Force("F0006","Desire to pick up meeting room keys in one place."),
			new Force("F0007","Desire to return keys in one place."),
			new Force("F0008","Tendency for people to not return keys."),
		    new Force("F0009","Difficulty in tracking down unreturned keys."),
		    new Force("F0010","Individuals have several meetings without gaps."),
		    new Force("F0011","Returning keys is often inconvenient."),
		    new Force("F0012","Frequent loss of meeting room keys."),
		    new Force("F0013","Inability to distinguish keys of meeting rooms."),
		    new Force("F0014","Use of high-quality equipment in meetings.")
		)
	}

	implicit val reader = Json.reads[Force]
	implicit val writer = Json.writes[Force] 
} 