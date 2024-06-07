import mill._, scalalib._, scalanativelib._, scalanativelib.api._

object hello extends ScalaNativeModule{
  override  def scalaNativeVersion = "0.5.0"
  override def scalaVersion = "3.4.1"
  def releaseMode = ReleaseMode.ReleaseFast
  def nativeLTO = LTO.Thin
}
