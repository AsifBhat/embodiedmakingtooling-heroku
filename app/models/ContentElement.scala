package models

case class ContentElement  (id: String,
                   description: String,
                   contentType: String,
                   relatedElements: List[String]) // This could be a list of related content elements - those that share a cluster with this element.  Or a list of clusters which contain this element.
                   
object ContentElement {
  
	def all(): List[ContentElement] = {
		List(new ContentElement("F0001","Meeting rooms are shared by a lot of people.","F", List()),
		    new ContentElement("F0002","Meeting rooms contain expensive equipment.","F", List()),
		    new ContentElement("F0003","Desire to protect equipment in meeting rooms.","F", List()),
		    new ContentElement("F0004","Limited number of meeting rooms.","F", List()),
		    new ContentElement("F0005","Meeting rooms are booked with a single point.","F", List()),
		    new ContentElement("F0006","Desire to pick up meeting room keys in one place.","F", List()),
			new ContentElement("F0007","Desire to return keys in one place.","F", List()),
			new ContentElement("F0008","Tendency for people to not return keys.","F", List()),
		    new ContentElement("F0009","Difficulty in tracking down unreturned keys.","F", List()),
		    new ContentElement("F0010","Individuals have several meetings without gaps.","F", List()),
		    new ContentElement("F0011","Returning keys is often inconvenient.","F", List()),
		    new ContentElement("F0012","Frequent loss of meeting room keys.","F", List()),
		    new ContentElement("F0013","Inability to distinguish keys of meeting rooms.","F", List()),
		    new ContentElement("F0014","Use of high-quality equipment in meetings.","F", List()),
		    new ContentElement("S0001","We share 10 meeting rooms, usually named after people to identify them, between 300 people, and the meeting rooms need to be kept locked.","S",List()),
		    new ContentElement("S0002","The receptionist helps book the room, and room users pick up the key, and usually drop it back.","S",List()),
		    new ContentElement("S0003","Although people are supposed to pick up and drop off the key with me, they rarely do. I have to run around and try and trace where the keys are.","S",List()),
		    new ContentElement("S0004","I often have back-to-back meetings, and I don’t always have time to return the key.","S",List()),
		    new ContentElement("S0005","We lose keys to meeting rooms all the time and have to replace all the locks 3 or 4 times a year.","S",List()),
		    new ContentElement("S0006","We need presentation equipment for meetings.","S",List()),
		    new ContentElement("C0001","Use large animal plush toys as keychains, a distinct one for each room.","C",List()),
			new ContentElement("C0002","Keep \"animals\" in a play pen in the reception.","C",List()),
			new ContentElement("C0003","Has anyone seen the water buffalo.","C",List()),
			new ContentElement("C0004","Name rooms after animals.","C",List()),
			new ContentElement("C0005","Bring \"animals\" back to their pen.","C",List()),
			new ContentElement("C0006","Play \"who's got the animal\" before and after meetings.","C",List()),
			new ContentElement("C0007","Create an animal themed cafe for small groups to meet.","C",List())
		)
  }

} 