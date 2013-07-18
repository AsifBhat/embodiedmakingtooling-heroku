package models


/*import play.api.Play.current
import java.util.Date
import com.novus.salat._
import com.novus.salat.annotations._
import com.novus.salat.dao._
import com.mongodb.casbah.Imports._
import play.api.libs.json._
import play.api.libs.functional.syntax._

import se.radley.plugin.salat._
import se.radley.plugin.salat.Binders._
import mongoContext._
*/

case class Story  (story_id: String,
                   description: String,
                   forcesDerived: List[String])
                   
object Story {
  
  def all(): List[Story] = {
		List(new Story("S0001","We share 10 meeting rooms, usually named after people to identify them, between 300 people, and the meeting rooms need to be kept locked.",List()),
		    new Story("S0002","The receptionist helps book the room, and room users pick up the key, and usually drop it back.",List()),
		    new Story("S0003","Although people are supposed to pick up and drop off the key with me, they rarely do. I have to run around and try and trace where the keys are.",List()),
		    new Story("S0004","I often have back-to-back meetings, and I don’t always have time to return the key.",List()),
		    new Story("S0005","We lose keys to meeting rooms all the time and have to replace all the locks 3 or 4 times a year.",List()),
		    new Story("S0006","We need presentation equipment for meetings.",List()))
  }

}                   
                   
/*object Story extends StoryDAO with StoryJson           
  
trait StoryDAO extends ModelCompanion[Story, ObjectId] {
  def collection = mongoCollection("stories")
  val dao = new SalatDAO[Story, ObjectId](collection) {}

  // Indexes
  //collection.ensureIndex(DBObject("username" -> 1), "user_email", unique = true)

  // Queries
  def findOneByUsername(username: String): Option[User] = dao.findOne(MongoDBObject("username" -> username))
  def findByCountry(country: String) = dao.find(MongoDBObject("address.country" -> country))
  def authenticate(username: String, password: String): Option[User] = findOne(DBObject("username" -> username, "password" -> password))
}

*//**
* Trait used to convert to and from json
*//*
trait StoryJson {

  implicit val storyJsonWrite = new Writes[Story] {
    def writes(story: Story): JsValue = {
      Json.obj(
        "story_id" -> story.story_id,
        "description" -> story.description,
        "forcesDerived" -> story.forcesDerived
      )
    }
  }
  implicit val storyJsonRead = (
    (__ \ 'story_id).read[ObjectId] ~
    (__ \ 'description).read[String] ~
    (__ \ 'forcesDerived).readNullable[List[String]] ~
  )(Story.apply _)
}*/