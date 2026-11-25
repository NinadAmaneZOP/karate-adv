package perf

import com.example.perf.LocalPerfMock
import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import scala.concurrent.duration._

// Profile 4: sustained traffic over a specified duration
class SustainedLoadSimulation extends Simulation {

  before {
    LocalPerfMock.start(18081)
  }

  after {
    LocalPerfMock.stop()
  }

  val protocol = karateProtocol()
  protocol.runner.karateEnv("perf")

  val scn = scenario("Sustained load - ping").exec(
    karateFeature("classpath:perf/ping-perf.feature")
  )

  setUp(
    scn.inject(
      // Warm-up: gradually start users, then sustain a steady arrival rate
      rampUsersPerSec(1) to (2) during (10 seconds), // ramp arrival rate from 1/sec to 2/sec
      constantUsersPerSec(2) during (30 seconds)     // sustain 2 users/sec for 30 seconds
    ).protocols(protocol)
  )
}
