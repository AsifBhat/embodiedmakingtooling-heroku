import sbt._
import Keys._
import play.Project._
import com.gu.SbtJasminePlugin._

object ApplicationBuild extends Build {

  val appName         = "EMtool"
  val appVersion      = "1.0-SNAPSHOT"
    

  val appDependencies = Seq(
    // Add your project dependencies here,
      "org.scalatest" %% "scalatest" % "1.9.1" % "test",
     "com.assembla.scala-incubator" % "graph-core_2.10" % "1.6.2" exclude("org.scala-lang", "scala-actors"),
    jdbc,
    anorm
  )

  val jasmimePluginProject = Project("sbtJasminePlugin", file("sbt-jasmine-plugin"))

  val main = play.Project(appName, appVersion, appDependencies).settings(
    // Add your own project settings here
      scalaVersion := "2.10.1",
      autoScalaLibrary := false,
      testOptions in Test := Nil
  )
  .settings(jasmineSettings : _*)  //this adds jasmine settings from the sbt-jasmine plugin into the project
  .settings(
    // Add your own project settings here
    // jasmine configuration, overridden as we don't follow the default project structure sbt-jasmine expects
    appJsDir <+= baseDirectory / "/target/scala-2.10/resource_managed/main/public/javascripts",
    //appJsDir <+= baseDirectory / "app/assets/javascripts",
    appJsLibDir <+= baseDirectory / "public/javascripts",
    jasmineTestDir <+= baseDirectory / "test/assets/",
    jasmineConfFile <+= baseDirectory / "test/assets/test.dependencies.js",
    // link jasmine to the standard 'sbt test' action. Now when running 'test' jasmine tests will be run, and if they pass
    // then other Play tests will be executed.
    (test in Test) <<= (test in Test) dependsOn (jasmine)
  ).dependsOn(jasmimePluginProject)

}
