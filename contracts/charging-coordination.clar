;; Charging Coordination Contract
;; Manages EV charging sessions and coordination

(define-constant ERR_UNAUTHORIZED (err u200))
(define-constant ERR_SESSION_EXISTS (err u201))
(define-constant ERR_SESSION_NOT_FOUND (err u202))
(define-constant ERR_INVALID_STATUS (err u203))
(define-constant ERR_STATION_UNAVAILABLE (err u204))

;; Session status constants
(define-constant SESSION_REQUESTED u0)
(define-constant SESSION_ACTIVE u1)
(define-constant SESSION_COMPLETED u2)
(define-constant SESSION_CANCELLED u3)

;; Data structures
(define-map charging-sessions
  { session-id: uint }
  {
    user: principal,
    station-id: uint,
    start-time: uint,
    end-time: uint,
    energy-requested: uint,
    energy-delivered: uint,
    status: uint,
    cost: uint
  }
)

(define-map station-availability
  { station-id: uint }
  {
    is-available: bool,
    current-session: (optional uint),
    queue-count: uint
  }
)

(define-data-var next-session-id uint u1)

;; Request a charging session
(define-public (request-charging-session (station-id uint) (energy-requested uint))
  (let ((session-id (var-get next-session-id)))
    (asserts! (is-none (map-get? charging-sessions { session-id: session-id })) ERR_SESSION_EXISTS)
    (asserts! (is-station-available station-id) ERR_STATION_UNAVAILABLE)

    (map-set charging-sessions
      { session-id: session-id }
      {
        user: tx-sender,
        station-id: station-id,
        start-time: u0,
        end-time: u0,
        energy-requested: energy-requested,
        energy-delivered: u0,
        status: SESSION_REQUESTED,
        cost: u0
      }
    )

    (var-set next-session-id (+ session-id u1))
    (ok session-id)
  )
)

;; Start a charging session
(define-public (start-charging-session (session-id uint))
  (match (map-get? charging-sessions { session-id: session-id })
    session-data
    (begin
      (asserts! (is-eq (get user session-data) tx-sender) ERR_UNAUTHORIZED)
      (asserts! (is-eq (get status session-data) SESSION_REQUESTED) ERR_INVALID_STATUS)

      (map-set charging-sessions
        { session-id: session-id }
        (merge session-data {
          start-time: block-height,
          status: SESSION_ACTIVE
        })
      )

      (map-set station-availability
        { station-id: (get station-id session-data) }
        {
          is-available: false,
          current-session: (some session-id),
          queue-count: u0
        }
      )

      (ok true)
    )
    ERR_SESSION_NOT_FOUND
  )
)

;; Complete a charging session
(define-public (complete-charging-session (session-id uint) (energy-delivered uint) (cost uint))
  (match (map-get? charging-sessions { session-id: session-id })
    session-data
    (begin
      (asserts! (is-eq (get user session-data) tx-sender) ERR_UNAUTHORIZED)
      (asserts! (is-eq (get status session-data) SESSION_ACTIVE) ERR_INVALID_STATUS)

      (map-set charging-sessions
        { session-id: session-id }
        (merge session-data {
          end-time: block-height,
          energy-delivered: energy-delivered,
          cost: cost,
          status: SESSION_COMPLETED
        })
      )

      (map-set station-availability
        { station-id: (get station-id session-data) }
        {
          is-available: true,
          current-session: none,
          queue-count: u0
        }
      )

      (ok true)
    )
    ERR_SESSION_NOT_FOUND
  )
)

;; Get session details
(define-read-only (get-session (session-id uint))
  (map-get? charging-sessions { session-id: session-id })
)

;; Check station availability
(define-read-only (is-station-available (station-id uint))
  (match (map-get? station-availability { station-id: station-id })
    availability-data (get is-available availability-data)
    true
  )
)

;; Get station availability details
(define-read-only (get-station-availability (station-id uint))
  (map-get? station-availability { station-id: station-id })
)
