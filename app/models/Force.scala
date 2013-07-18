package models

case class Force  (force_id: String,
                   description: String,
                   inspirations: List[String],
                   involvedInteractions:List[String])
                   
object Force {
  
  def all(): List[Force] = {
		List(new Force("F0001","Meeting rooms are shared by a lot of people.",List(),List()),
		    new Force("F0002","Meeting rooms contain expensive equipment.",List(),List()),
		    new Force("F0003","Desire to protect equipment in meeting rooms.",List(),List()),
		    new Force("F0004","Limited number of meeting rooms.",List(),List()),
		    new Force("F0005","Meeting rooms are booked with a single point.",List(),List()),
		    new Force("F0006","Desire to pick up meeting room keys in one place.",List(),List()),
			new Force("F0007","Desire to return keys in one place.",List(),List()),
			new Force("F0008","Tendency for people to not return keys.",List(),List()),
		    new Force("F0009","Difficulty in tracking down unreturned keys.",List(),List()),
		    new Force("F0010","Individuals have several meetings without gaps.",List(),List()),
		    new Force("F0011","Returning keys is often inconvenient.",List(),List()),
		    new Force("F0012","Frequent loss of meeting room keys.",List(),List()),
		    new Force("F0013","Inability to distinguish keys of meeting rooms.",List(),List()),
		    new Force("F0014","Use of high-quality equipment in meetings.",List(),List())
		)
  }

} 