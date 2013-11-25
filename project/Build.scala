import sbt._
import Keys._
import play.Project._
import com.gu.SbtJasminePlugin._
import coffeescript.Plugin._


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

  val copyAssets = TaskKey[Unit]("copy-assets")
 
  val jasmimePluginProject = Project("sbtJasminePlugin", file("sbt-jasmine-plugin"))

  val main = play.Project(appName, appVersion, appDependencies).settings(
      scalaVersion := "2.10.1",
      autoScalaLibrary := false,
      testOptions in Test := Nil,
      //lessEntryPoints <<= baseDirectory(_ / "app" / "assets" / "stylesheets" ** "main.less"),
      copyAssets <<= ( baseDirectory in Compile , resourceManaged in Compile) map { (b, r) =>
        val jssrc = b / "app/assets/javascripts" 
        val jsdst = r / "public/javascripts"
        val jssrcDst = (jssrc ** "*.js" ).get map {f => 
          val jspathRelativeToViewsFolder = f.getPath.substring(jssrc.getPath.length)
          val jsdstPath = jsdst / jspathRelativeToViewsFolder
          (f, jsdstPath)
        }
        IO.copy( jssrcDst )
        // Copying css
        /*val csssrc = b / "app/assets/stylesheets" 
        val cssdst = r / "public/stylesheets"
        val csssrcDst = (csssrc ** "*.css" ).get map {f => 
          val csspathRelativeToViewsFolder = f.getPath.substring(csssrc.getPath.length)
          val cssdstPath = cssdst / csspathRelativeToViewsFolder
          (f, cssdstPath)
        }
        IO.copy( csssrcDst )*/

      }
  )
  .settings(coffeeSettings: _*)
  .settings(
	  sourceDirectory in (Compile, CoffeeKeys.coffee) <<= (sourceDirectory in Compile)(_ / "assets" / "javascripts"),
	  resourceManaged in (Compile, CoffeeKeys.coffee) <<= (resourceManaged in Compile)(_ / "public" / "javascripts")
  )

  /* .settings(lessSettings : _*)
  .settings(
    (sourceDirectory in (Compile, LessKeys.less)) <<= (sourceDirectory in Compile)(_ / "assets" / "stylesheets" ),
    //(resourceManaged in (Compile, StyleKeys.less)) <<= (sourceDirectory in Compile)(_ / "public" / "stylesheets")
    (resourceManaged in (Compile, LessKeys.less)) <<= (crossTarget in Compile)(_ / "public" / "stylesheets")
  )*/

  .settings(jasmineSettings : _*)  //this adds jasmine settings from the sbt-jasmine plugin into the project
  .settings(
    // jasmine configuration, overridden as we don't follow the default project structure sbt-jasmine expects
    appJsDir <+= baseDirectory / "app/assets/javascripts",
    appJsLibDir <+= baseDirectory / "public/javascripts",    
    jasmineTestDir <+= baseDirectory / "test/assets/",
    jasmineConfFile <+= baseDirectory / "test/assets/test.dependencies.js",
    // link jasmine to the standard 'sbt test' action. Now when running 'test' jasmine tests will be run, and if they pass
    // then other Play tests will be executed.
    //(compile in Compile) <<= (compile in Compile) dependsOn (LessKeys.less in Compile),
    (test in Test) <<= (test in Test) dependsOn (jasmine),
    (jasmine) <<= (jasmine) dependsOn (CoffeeKeys.coffee in Compile),
    (playCopyAssets) <<= (playCopyAssets) dependsOn (copyAssets)
  ) 
  .dependsOn(jasmimePluginProject).aggregate(jasmimePluginProject)


}

