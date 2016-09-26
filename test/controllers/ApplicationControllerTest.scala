package controllers

import org.scalatest._

class ApplicationControllerTest extends FreeSpec {

  "Application controller" - {
    "does something" in {
      val controller = new Application
      val res = controller.hello
      assert(res == "hello!")
    }
  }

}
