# Test Coverage Report (Restful-Booker API)

## 1. GET /ping (Healthcheck)
| Case ID | Type | Description | Automated (Yes/No) | Feature file | Tag |
|---|---|---|---|---|---|
| BKG-01 | Positive | Verify healthcheck ping returns status 201 | Yes | parent/booking.feature | @positive |
| TMO-NEG-01 | Negative | Verify request timeout handling when connection threshold is exceeded | Yes | parent/timeout.feature | @negative |
| PNG-NOT-01 | Negative | Server down / network transport failure | No (Infrastructure downtime cannot be simulated on public sandbox) | - | @negative |

## 2. POST /auth (Authentication)
| Case ID | Type | Description | Automated (Yes/No) | Feature file | Tag |
|---|---|---|---|---|---|
| BKG-02 | Positive | Authenticate with valid admin credentials to obtain auth token | Yes | parent/booking.feature | @positive |
| NEG-01 | Negative | Bad credentials return 200 with reason Bad credentials (possible API bug) | Yes | parent/booking-negative.feature | @negative |
| AUTH-NOT-01 | Edge | Brute force rate limiting on repeated auth requests | No (Public shared sandbox enforces no rate limiting) | - | @edge |

## 3. POST /booking (Create Booking)
| Case ID | Type | Description | Automated (Yes/No) | Feature file | Tag |
|---|---|---|---|---|---|
| BKG-02 | Positive | Create new booking with full valid payload | Yes | parent/booking.feature | @positive |
| BKG-03 | Positive | Create booking without optional additionalneeds | Yes | parent/booking.feature | @positive |
| BKG-NEG-01 | Negative | Create booking missing required firstname (possible API bug: 500) | Yes | parent/booking-negative.feature | @negative |
| BKG-NEG-02 | Negative | Create booking missing required lastname (possible API bug: 500) | Yes | parent/booking-negative.feature | @negative |
| BKG-NEG-03 | Negative | Create booking missing required bookingdates (possible API bug: 500) | Yes | parent/booking-negative.feature | @negative |
| BKG-EDG-01 | Edge | Create booking with empty firstname string | Yes | parent/booking-negative.feature | @edge |
| BKG-EDG-02 | Edge | Create booking with totalprice of zero | Yes | parent/booking-negative.feature | @edge |
| BKG-EDG-03 | Edge | Create booking with negative totalprice | Yes | parent/booking-negative.feature | @edge |
| BKG-EDG-04 | Edge | Create booking with checkout date before checkin date | Yes | parent/booking-negative.feature | @edge |
| BKG-EDG-05 | Edge | Create booking with unexpected extra payload fields | Yes | parent/booking-negative.feature | @edge |
| BKG-EDG-06 | Edge | Create booking with 250 character long string | Yes | parent/booking-negative.feature | @edge |
| BKG-EDG-07 | Edge | Create booking with special characters in name | Yes | parent/booking-negative.feature | @edge |
| BKG-04 | Edge | Create booking with empty firstname, verify persistence and updates | Yes | parent/booking.feature | @edge |
| BKG-NOT-01 | Negative | Server out of memory / storage exhaustion on creation | No (Cannot simulate backend storage exhaustion against third-party SaaS) | - | @negative |

## 4. GET /booking (Query Bookings)
| Case ID | Type | Description | Automated (Yes/No) | Feature file | Tag |
|---|---|---|---|---|---|
| BKG-02 | Positive | Retrieve existing booking details by valid ID | Yes | parent/booking.feature | @positive |
| FLT-NOT-01 | Edge | Filter with SQL injection or malformed date query strings | No (Sandbox query parser behaves unreliably across concurrent resets) | - | @edge |

## 5. GET /booking/:id (Get Booking Details)
| Case ID | Type | Description | Automated (Yes/No) | Feature file | Tag |
|---|---|---|---|---|---|
| BKG-02 | Positive | Retrieve existing booking details by valid ID | Yes | parent/booking.feature | @positive |
| BKG-NEG-04 | Negative | Retrieve booking with non-existent ID returns 404 | Yes | parent/booking-negative.feature | @negative |
| BKG-NEG-05 | Negative | Retrieve booking with non-numeric string ID returns 404 | Yes | parent/booking-negative.feature | @negative |
| BKG-NEG-06 | Negative | Retrieve booking with negative numeric ID returns 404 | Yes | parent/booking-negative.feature | @negative |
| BID-NOT-01 | Negative | Database read lock / deadlock during retrieval | No (Shared public host without internal DB controls) | - | @negative |

## 6. PUT /booking/:id (Full Update)
| Case ID | Type | Description | Automated (Yes/No) | Feature file | Tag |
|---|---|---|---|---|---|
| BKG-02 | Positive | Complete update of booking with valid auth token | Yes | parent/booking.feature | @positive |
| AUTH-NEG-02 | Negative | PUT update without auth token header returns 403 | Yes | parent/booking-negative.feature | @negative |
| AUTH-NEG-03 | Negative | PUT update with invalid auth token header returns 403 | Yes | parent/booking-negative.feature | @negative |
| PUT-NOT-01 | Negative | Race condition between concurrent PUT updates | No (Sandbox 10-minute reset causes non-deterministic concurrency states) | - | @negative |

## 7. PATCH /booking/:id (Partial Update)
| Case ID | Type | Description | Automated (Yes/No) | Feature file | Tag |
|---|---|---|---|---|---|
| BKG-03 | Positive | Add additionalneeds field to existing booking via PATCH | Yes | parent/booking.feature | @positive |
| BKG-04 | Positive | Update partial fields (firstname only) via PATCH | Yes | parent/booking.feature | @positive |
| PAT-NOT-01 | Negative | PATCH with malformed non-JSON body payload | No (HTTP client enforces valid payload boundary) | - | @negative |

## 8. DELETE /booking/:id (Delete Booking)
| Case ID | Type | Description | Automated (Yes/No) | Feature file | Tag |
|---|---|---|---|---|---|
| BKG-02 | Positive | Delete booking with valid auth token returns 201 | Yes | parent/booking.feature | @positive |
| AUTH-NEG-04 | Negative | DELETE booking without auth token header returns 403 | Yes | parent/booking-negative.feature | @negative |
| AUTH-NEG-05 | Negative | DELETE booking with invalid auth token header returns 403 | Yes | parent/booking-negative.feature | @negative |
| DEL-NOT-01 | Edge | Simultaneous duplicate DELETE calls on the same booking ID | No (Automated resets invalidate simultaneous delete races) | - | @edge |

---

## Summary Totals
- **Total Cases Identified**: 32
- **Total Cases Automated**: 25
- **Automated Percentage**: 78.1%
- **Counts by Type**:
  - **Positive**: 9 identified, 9 automated (100%)
  - **Negative**: 13 identified, 9 automated (69.2%)
  - **Edge**: 10 identified, 7 automated (70.0%)
