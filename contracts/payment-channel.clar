;; Title: Payment Channel Smart Contract
;; Summary:
;; A trustless payment channel implementation that enables off-chain transactions
;; with on-chain settlement. Supports bilateral channels with cooperative and
;; unilateral closing mechanisms.
;;
;; Description:
;; This contract implements a state channel system that allows two parties to:
;; - Create and fund payment channels
;; - Conduct multiple off-chain transactions
;; - Close channels cooperatively with latest agreed state
;; - Handle disputes through unilateral closing with challenge period
;; - Emergency withdrawal functionality for contract owner
;;
;; Security Features:
;; - Signature verification for state updates
;; - Challenge period for unilateral closes
;; - Balance validation
;; - Input validation
;; - Principal separation checks

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-CHANNEL-EXISTS (err u101))
(define-constant ERR-CHANNEL-NOT-FOUND (err u102))
(define-constant ERR-INSUFFICIENT-FUNDS (err u103))
(define-constant ERR-INVALID-SIGNATURE (err u104))
(define-constant ERR-CHANNEL-CLOSED (err u105))
(define-constant ERR-DISPUTE-PERIOD (err u106))
(define-constant ERR-INVALID-INPUT (err u107))

;; Data Maps
(define-map payment-channels 
  {
    channel-id: (buff 32),
    participant-a: principal,
    participant-b: principal
  }
  {
    total-deposited: uint,
    balance-a: uint,
    balance-b: uint,
    is-open: bool,
    dispute-deadline: uint,
    nonce: uint
  }
)

;; Input Validation Functions
(define-private (is-valid-channel-id (channel-id (buff 32)))
  (and 
    (> (len channel-id) u0)
    (<= (len channel-id) u32)
  )
)

(define-private (is-valid-deposit (amount uint))
  (> amount u0)
)

(define-private (is-valid-signature (signature (buff 65)))
  (is-eq (len signature) u65)
)
