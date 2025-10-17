;; title: Anti-Currency-Token
;; version: 1.0.0
;; summary: A token that shrinks in supply with every transaction
;; description: Anti-Currency Token burns a percentage of tokens on each transfer, creating deflationary pressure

;; constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-OWNER-ONLY (err u100))
(define-constant ERR-INSUFFICIENT-BALANCE (err u102))
(define-constant ERR-ALREADY-INITIALIZED (err u103))
(define-constant ERR-INVALID-AMOUNT (err u104))
(define-constant ERR-INVALID-RECIPIENT (err u105))
(define-constant BURN-RATE u5) ;; 5% burn on each transfer

;; data vars
(define-data-var token-name (string-ascii 32) "Anti-Currency Token")
(define-data-var token-symbol (string-ascii 10) "ACT")
(define-data-var token-decimals uint u6)
(define-data-var total-supply uint u1000000000000) ;; 1M tokens with 6 decimals
(define-data-var initialized bool false)
(define-data-var total-burned uint u0)

;; Initialize contract with total supply to owner
(define-public (initialize)
    (begin
        (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-OWNER-ONLY)
        (asserts! (not (var-get initialized)) ERR-ALREADY-INITIALIZED)
        (try! (ft-mint? anti-currency-token u1000000000000 CONTRACT-OWNER))
        (var-set initialized true)
        (ok true)
    )
)

;; public functions
(define-public (transfer (amount uint) (recipient principal))
    (let 
        (
            (sender tx-sender)
            (burn-amount (/ (* amount BURN-RATE) u100))
            (transfer-amount (- amount burn-amount))
        )
        (asserts! (> amount u0) ERR-INVALID-AMOUNT)
        (asserts! (not (is-eq sender recipient)) ERR-INVALID-AMOUNT)
        (and (> burn-amount u0) 
             (begin
                (try! (ft-burn? anti-currency-token burn-amount sender))
                (var-set total-supply (- (var-get total-supply) burn-amount))
                (var-set total-burned (+ (var-get total-burned) burn-amount))
             )
        )
        (try! (ft-transfer? anti-currency-token transfer-amount sender recipient))
        (ok {transferred: transfer-amount, burned: burn-amount})
    )
)

(define-public (mint (amount uint) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-OWNER-ONLY)
        (asserts! (> amount u0) ERR-INVALID-AMOUNT)
        (asserts! (is-standard recipient) ERR-INVALID-RECIPIENT)
        (try! (ft-mint? anti-currency-token amount recipient))
        (var-set total-supply (+ (var-get total-supply) amount))
        (ok amount)
    )
)

;; read only functions
(define-read-only (get-name)
    (ok (var-get token-name))
)

(define-read-only (get-symbol)
    (ok (var-get token-symbol))
)

(define-read-only (get-decimals)
    (ok (var-get token-decimals))
)

(define-read-only (get-balance (who principal))
    (ok (ft-get-balance anti-currency-token who))
)

(define-read-only (get-total-supply)
    (ok (var-get total-supply))
)

(define-read-only (get-total-burned)
    (ok (var-get total-burned))
)

(define-read-only (is-initialized)
    (ok (var-get initialized))
)

;; token definitions
(define-fungible-token anti-currency-token)

