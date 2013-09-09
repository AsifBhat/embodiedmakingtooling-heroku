package models

case class SolutionComponent(id: String, description: String) extends ContentElement

object SolutionComponent {
  def all(): List[SolutionComponent] = List(
    new SolutionComponent("C0001", "Use large animal plush toys as keychains, a distinct one for each room."),
    new SolutionComponent("C0002", "Keep \"animals\" in a play pen in the reception."),
    new SolutionComponent("C0003", "Has anyone seen the water buffalo."),
    new SolutionComponent("C0004", "Name rooms after animals."),
    new SolutionComponent("C0005", "Bring \"animals\" back to their pen."),
    new SolutionComponent("C0006", "Play \"who's got the animal\" before and after meetings."),
    new SolutionComponent("C0007", "Create an animal themed cafe for small groups to meet.")
  )

  def getElementById(id: String): Option[SolutionComponent] = all().find(_.id == id)
}
                  
