package models


case class ClusterEntity(var id:String, relations: List[(String, List[String])]){
  
  private var graphRelations: List[(ContentElement,ContentElement)] = getGraphRelations
  
  private var cluster = if(graphRelations.length==0) {
    val rootelem = getContentElement(relations(0)._1)
    new Cluster(id,List((rootelem,rootelem)))
  }
  else new Cluster(id,graphRelations)
  
  
  def getGraphRelations : List[(ContentElement,ContentElement)] = {
    relations.map(rel => rel._2.map(dest => (getContentElement(rel._1) ,getContentElement(dest)))).flatten
  }
  
  private def getContentElement(id:String):ContentElement ={
    val contentElementType = id.subSequence(0, 1)
    val element = contentElementType match {
      case "F" => Force.getElementById(id).get
      case "S" => Story.getElementById(id).get
      case "C" => SolutionComponent.getElementById(id).get
    }
    element
  }
  
  def getCluster = {this.cluster}
  
  override def toString() = {
    val prnid = "Cluster ID: "+id+"\n"
    val prnrel = relations.map(rel => rel._1 +" -> "+ rel._2)
    prnid+prnrel
  }
  
}

object ClusterEntity{
  
  var nextIdCnt = 6
  
  var allClusters: List[ClusterEntity] = List(
  
   new ClusterEntity ("G1",
    List(("C0001", List("F0005","F0006","F0011","F0012")),
      ("F0005", List("F0006","F0004","F0007")),
      ("F0006",List("F0007","F0013")),
      ("F0004", List("F0007")),
      ("F0007", List("F0013")),
      ("F0012", List("F0011"))
        )   
   ),   
    new ClusterEntity ("G2",
    List(("S0004", List("F0010","F0001")),
      ("F0010", List("F0002"))
        )   
   ),
   new ClusterEntity ("G3",
    List(("C0001", List("F0005","F0006","F0011","F0012")),
      ("F0005", List("F0006","F0004","F0007")),
      ("F0006",List("F0007","F0013")),
      ("F0004", List("F0007")),
      ("F0007", List("F0013")),
      ("F0012", List("F0011"))
        )   
   ),
   new ClusterEntity("G4",
        List(("S0004",List("F0010")),
            ("F0010",List("F0011")),
            ("F0011",List("F0012"))
            )
   ),
   new ClusterEntity("G5",
        List(("S0004",List("F0010","F0011","F0012"))
        )   
  )
)
  
  def all: List[ClusterEntity] = allClusters
  
  def addClusterToMem(newCluster: ClusterEntity):ClusterEntity={
    val nextId = "G"+nextIdCnt
    var clusterToAdd = new ClusterEntity(nextId,newCluster.relations.sortBy(r => 0-r._2.length))
    nextIdCnt = nextIdCnt+1
    allClusters = clusterToAdd::allClusters
    clusterToAdd
  }
    
  def getClusterById(id: String): Option[ClusterEntity] = all.find(c => c.id==id)
}

