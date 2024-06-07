import mill._
import mill.scalalib._
import  scalanativelib._, scalanativelib.api._

object hello extends ScalaModule {

  def scalaNativeVersion = "0.5.0"
  def scalaVersion = "3.4.1"
    def releaseMode = ReleaseMode.ReleaseFast
  def nativeLTO = LTO.Thin

  object test extends ScalaTests with TestModule.Munit {
    def ivyDeps = Agg(
      ivy"org.scalameta::munit::0.7.29"
    )
  }
}

