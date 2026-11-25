package perf

import com.example.perf.LocalPerfMock
import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import scala.concurrent.duration._

class PingLoadSimulation extends Simulation {

  // Runs once before the load test starts
  before {
    // Start a local mock server so we do NOT send load to public APIs
    LocalPerfMock.start(18081)
  }

  // Runs once after the load test finishes
  after {
    // Stop the local mock server
    LocalPerfMock.stop()
  }

  // Karate protocol/config bridge for Gatling
  val protocol = karateProtocol()
  // Use karate-config.js with env = "perf" so base URLs point to localhost
  protocol.runner.karateEnv("perf")

  // A Gatling "scenario" (a user journey) that executes a Karate feature
  val pingScenario = scenario("Ping local mock").exec(
    karateFeature("classpath:perf/ping-perf.feature")
  )

  // Define the load: 3 virtual users, gradually started over 10 seconds
  setUp(
    pingScenario.inject(rampUsers(3) during (10 seconds)).protocols(protocol)
  )
}
