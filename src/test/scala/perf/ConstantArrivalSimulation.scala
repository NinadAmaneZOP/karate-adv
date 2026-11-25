package perf

import com.example.perf.LocalPerfMock
import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import scala.concurrent.duration._

// Profile 3: constant arrival rate (open model)
class ConstantArrivalSimulation extends Simulation {

  before {
    LocalPerfMock.start(18081)
  }

  after {
    LocalPerfMock.stop()
  }

  val protocol = karateProtocol()
  protocol.runner.karateEnv("perf")

  val scn = scenario("Constant arrival rate - ping").exec(
    karateFeature("classpath:perf/ping-perf.feature")
  )

  setUp(
    scn.inject(
      constantUsersPerSec(2) during (20 seconds) // inject 2 users per second for 20 seconds
    ).protocols(protocol)
  )
}
