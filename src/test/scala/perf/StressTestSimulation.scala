package perf

import com.example.perf.LocalPerfMock
import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import scala.concurrent.duration._

// Stage 5: Stress test (local demo) - gradually increase traffic beyond normal
// Safety: runs against local mock server only (no public APIs).
class StressTestSimulation extends Simulation {

  before {
    LocalPerfMock.start(18081)
  }

  after {
    LocalPerfMock.stop()
  }

  val protocol = karateProtocol()
  protocol.runner.karateEnv("perf")

  val scn = scenario("Stress test - ping").exec(
    karateFeature("classpath:perf/ping-perf.feature")
  )

  setUp(
    scn.inject(
      // 1) Warm-up: normal/low traffic
      rampUsersPerSec(1) to (5) during (20 seconds),
      // 2) Sustained moderate traffic
      constantUsersPerSec(5) during (20 seconds),
      // 3) Stress phase: push beyond normal
      rampUsersPerSec(5) to (15) during (30 seconds),
      // 4) High stress hold: observe response times/errors
      constantUsersPerSec(15) during (20 seconds)
    ).protocols(protocol)
  )
}
