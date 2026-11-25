# Karate API Test Automation Suite

Simple, modular Karate test suite for Restful-Booker and DummyJSON APIs.

## Architecture
- `src/test/java/com/example/runner/TestRunner.java`: TestNG runner using `Runner.path(...).parallel(n)`
- `src/test/resources/parent/`: Core feature files (Main CRUD, Negatives/Edges, Complex Validations, Timeout, Load/Stress)
- `src/test/resources/utils/`: Reusable API callers, assertions, schemas, test data, and JS helpers

## Parent Feature Files
1. `parent/booking.feature`: Restful-Booker main positive workflows (auth chaining, CRUD, optional fields, empty field).
2. `parent/booking-negative.feature`: Negative and edge case outlines driven by CSV files.
3. `parent/complex-validations.feature`: 15 advanced data validations on DummyJSON `/products`.
4. `parent/timeout.feature`: Connection timeout failure assertion.
5. `parent/load-stress.feature`: Read-only concurrent API requests tagged `@load` for load/stress validation.

## Maven Commands

### 1. Run All Tests
```bash
mvn clean test
```

### 2. Run Functional Test Suite (excluding timeout injection)
```bash
mvn -B test -Dtags="~@timeout"
```

### 3. Run by Tag
```bash
mvn test -Dtags="@smoke"
```

### 4. Run Load/Stress Tests
```bash
mvn -B test -Dtags="@load" -Dthreads=10
```

### 5. Run Excluding a Tag
```bash
mvn test -Dtags="~@timeout"
```

### 6. Run One Specific Feature
```bash
mvn test -Dfeature="complex-validations.feature"
```

### 7. Run in Parallel with 4 Threads
```bash
mvn test -Dthreads=4
```

## Gatling Performance Testing (Local/Safe by Default)
- Gatling is configured via the Maven `gatling` profile in `pom.xml` (Karate 1.4.1 + karate-gatling, no dependency upgrades).
- Performance simulations are in `src/test/scala/perf/` and reuse Karate features/helpers.
- Safety: perf simulations use `karate.env=perf` to target a local mock server (`localhost:18081`) started by the simulation. **Do not run heavy load/stress against public APIs without explicit authorization.**
- Run a simulation locally (use JDK 17 for Scala/Gatling compatibility in this setup):
```bash
JAVA_HOME=$(/usr/libexec/java_home -v 17) mvn test-compile gatling:test -Pgatling -Dgatling.simulationClass=perf.PingLoadSimulation
```
- Available simulations: `SmallLoadSimulation`, `GradualLoadSimulation`, `ConstantArrivalSimulation`, `SustainedLoadSimulation`, `StressTestSimulation`.
- Gatling HTML reports: `target/gatling/<simulation-name>-<timestamp>/index.html`.

## CI Workflow
- `.github/workflows/ci.yml` defines separate jobs:
  - **Functional test suite**: runs `mvn -B test -Dtags="~@timeout"` to verify functional test cases pass.
  - **Load and stress tests (Karate parallel)**: runs `mvn -B test -Dtags="@load" -Dthreads=10` for tagged Karate concurrency/stress scenarios.
  - **Gatling performance tests**: runs `mvn -B test-compile gatling:test -Pgatling -Dgatling.simulationClass=perf.PingLoadSimulation` (local mock, conservative) and uploads `target/gatling` reports.
- Karate/Gatling reports are uploaded as workflow artifacts.

## Reports
HTML report is generated upon test execution at:
`target/karate-reports/karate-summary.html`
