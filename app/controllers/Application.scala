package controllers

import com.google.inject.Inject
import play.api.mvc.{Action, AnyContent, Controller}

class Application @Inject()() extends Controller {

  def testPage(): Action[AnyContent] = Action {
    Ok(views.html.testPage())
  }

  def hello: String = "hello!"

}
