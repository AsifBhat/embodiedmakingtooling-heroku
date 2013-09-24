package rest

import org.specs2.mutable._

class BaseSpec extends Specification {
  val port = 3333
  val timeout = 2000
  val baseUrl = s"http://localhost:$port"
  val baseApi = s"$baseUrl/api"
}
