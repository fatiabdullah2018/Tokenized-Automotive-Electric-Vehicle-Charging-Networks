;; Charging Station Verification Contract
;; Validates and manages EV charging stations

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_STATION_EXISTS (err u101))
(define-constant ERR_STATION_NOT_FOUND (err u102))
(define-constant ERR_INVALID_STATUS (err u103))

;; Station status constants
(define-constant STATUS_PENDING u0)
(define-constant STATUS_VERIFIED u1)
(define-constant STATUS_SUSPENDED u2)

;; Data structures
(define-map charging-stations
  { station-id: uint }
  {
    owner: principal,
    location: (string-ascii 100),
    power-capacity: uint,
    status: uint,
    verification-date: uint,
    total-sessions: uint
  }
)

(define-map station-operators
  { operator: principal }
  { verified: bool, station-count: uint }
)

(define-data-var next-station-id uint u1)

;; Register a new charging station
(define-public (register-station (location (string-ascii 100)) (power-capacity uint))
  (let ((station-id (var-get next-station-id)))
    (asserts! (is-none (map-get? charging-stations { station-id: station-id })) ERR_STATION_EXISTS)
    (map-set charging-stations
      { station-id: station-id }
      {
        owner: tx-sender,
        location: location,
        power-capacity: power-capacity,
        status: STATUS_PENDING,
        verification-date: u0,
        total-sessions: u0
      }
    )
    (var-set next-station-id (+ station-id u1))
    (ok station-id)
  )
)

;; Verify a charging station (admin only)
(define-public (verify-station (station-id uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (match (map-get? charging-stations { station-id: station-id })
      station-data
      (begin
        (map-set charging-stations
          { station-id: station-id }
          (merge station-data {
            status: STATUS_VERIFIED,
            verification-date: block-height
          })
        )
        (ok true)
      )
      ERR_STATION_NOT_FOUND
    )
  )
)

;; Get station details
(define-read-only (get-station (station-id uint))
  (map-get? charging-stations { station-id: station-id })
)

;; Check if station is verified
(define-read-only (is-station-verified (station-id uint))
  (match (map-get? charging-stations { station-id: station-id })
    station-data (is-eq (get status station-data) STATUS_VERIFIED)
    false
  )
)

;; Update station session count
(define-public (increment-session-count (station-id uint))
  (match (map-get? charging-stations { station-id: station-id })
    station-data
    (begin
      (map-set charging-stations
        { station-id: station-id }
        (merge station-data {
          total-sessions: (+ (get total-sessions station-data) u1)
        })
      )
      (ok true)
    )
    ERR_STATION_NOT_FOUND
  )
)
