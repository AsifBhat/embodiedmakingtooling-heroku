package models

case class ForceInteraction  (primary_force: String,
                   reinforcing: List[String],
                   conflicting: List[String],
                   neutral:List[String])
                   
                  
object ForceInteraction {
  type FI = ForceInteraction 
  def all(): List[ForceInteraction] = {
		List(new FI("F0001",List("F0005","F0006","F00007"),List("F0003","F0004","F0008","F0009","F0010","F0012","F0013"),List()),
		new FI("F0002",List(),List("F0003","F0008","F0009","F0012","F0013"),List()),
		new FI("F0010",List("F0005"),List("F0001","F0004","F0011","F0012","F0013"),List()),
		new FI("F0013",List(),List("F0001","F0002","F0005","F0006","F0007","F0008","F0009","F0011","F0012"),List())		
		)
  }

} 