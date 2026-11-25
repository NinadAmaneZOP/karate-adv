package perf

import com.example.perf.LocalPerfMock
import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import scala.concurrent.duration._

// Profile 1: very small load to verify performance test setup works
class SmallLoadSimulation extends Simulation {

  before {
    LocalPerfMock.start(18081) // start safe local mock server
  }

  after {
    LocalPerfMock.stop() // stop mock server after test
  }

  val protocol = karateProtocol()
  protocol.runner.karateEnv("perf") // use local perf URLs from karate-config.js

  val scn = scenario("Small load - ping").exec(
    karateFeature("classpath:perf/ping-perf.feature")
  )

  setUp(
    scn.inject(
      rampUsers(2) during (5 seconds) // start 2 virtual users gradually over 5 seconds
    ).protocols(protocol)
  )
}
