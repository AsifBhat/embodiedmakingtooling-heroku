import sbt._
import Keys._
import play.Project._

object ApplicationBuild extends Build {

  val appName         = "EMtool"
  val appVersion      = "1.0-SNAPSHOT"

  val appDependencies = Seq(
    // Add your project dependencies here,
      "org.scalatest" %% "scalatest" % "1.9.1" % "test",
    jdbc,
    anorm
  )


  val main = play.Project(appName, appVersion, appDependencies).settings(
    // Add your own project settings here    
      testOptions in Test := Nil
  )

}
