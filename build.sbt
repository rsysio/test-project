name := "test-project"

version := "0.0.1-SNAPSHOT"

lazy val root = (project in file("."))
  .enablePlugins(PlayScala)
  .enablePlugins(JavaAppPackaging)

scalaVersion := "2.11.7"

libraryDependencies ++= Seq(
  ws,
  "com.microsoft.azure" % "applicationinsights-web" % "1.0.5",
  "org.scalatest" %% "scalatest" % "3.0.0" % "test"
)

maintainer:= "Stuart Mcvean"

dockerExposedPorts in Docker := Seq(9000, 9443)

routesGenerator := InjectedRoutesGenerator
