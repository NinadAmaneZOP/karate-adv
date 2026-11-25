package perf

import com.example.perf.LocalPerfMock
import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import scala.concurrent.duration._

// Profile 2: gradually increasing users (ramp-up)
class GradualLoadSimulation extends Simulation {

  before {
    LocalPerfMock.start(18081)
  }

  after {
    LocalPerfMock.stop()
  }

  val protocol = karateProtocol()
  protocol.runner.karateEnv("perf")

  val scn = scenario("Gradual load - ping").exec(
    karateFeature("classpath:perf/ping-perf.feature")
  )

  setUp(
    scn.inject(
      rampUsers(10) during (30 seconds) // gradually start 10 users over 30 seconds
    ).protocols(protocol)
  )
}
