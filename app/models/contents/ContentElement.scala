package models.contents

import play.api.libs.json._
import play.api.libs.functional.syntax._

abstract class ContentElement (_id:String ,description:String)  {
  require(description.length()>0, "The description must not be empty")
  
  def id = _id
}
                   

	
