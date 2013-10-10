package models

case class PositionForHexGrid (posId:String, elementId: String, clusterId: String, xPos: Int, yPos: Int)

object PositionForHexGrid {
  
  var allPos =  List(
    new PositionForHexGrid("P0001","S0005","G5",0,0),
    new PositionForHexGrid("P0002","F0010","G5",0,1),
    new PositionForHexGrid("P0003","F0011","G5",-1,0),
    new PositionForHexGrid("P0004","F0012","G5",1,-1)
  )
  
  var nextIdCnt = 5
  
  def all(): List[PositionForHexGrid] = allPos

  def addPosToMem(newPos: PositionForHexGrid):PositionForHexGrid={
    val nextId = "P"+nextIdCnt
    var posToAdd = new PositionForHexGrid(nextId, newPos.elementId,newPos.clusterId, newPos.xPos,newPos.yPos)
    nextIdCnt = nextIdCnt+1
    allPos = posToAdd::allPos
    posToAdd
  }
}