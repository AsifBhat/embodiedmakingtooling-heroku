package models

case class SolutionComponent(sol_id: String,
  description: String,
  favored: List[String], // Favoured forces / wills
  affected: List[String],
  unresolved: List[String])
  
object SolutionComponent{
  type SC = SolutionComponent
  def all ():List[SC]={
    List(
    	new SC("C0001","Use large animal plush toys as keychains, a distinct one for each room.",List(),List(),List()),
    	new SC("C0002","Keep \"animals\" in a play pen in the reception.",List(),List(),List()),
    	new SC("C0003","Has anyone seen the water buffalo.",List(),List(),List()),
    	new SC("C0004","Name rooms after animals.",List(),List(),List()),
    	new SC("C0005","Bring \"animals\" back to their pen.",List(),List(),List()),
    	new SC("C0006","Play \"who's got the animal\" before and after meetings.",List(),List(),List()),
    	new SC("C0007","Create an animal themed cafe for small groups to meet.",List(),List(),List())
    )
  }
  
}  
                  
