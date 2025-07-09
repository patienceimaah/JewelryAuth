;; JewelryAuth - Handcrafted jewelry authentication and artisan verification system
(define-map jewelry-pieces uint {
  artisan: principal,
  piece-type: (string-utf8 64),
  crafting-techniques: (string-utf8 256),
  creation-date: uint,
  materials-used: (string-utf8 64),
  authenticity-verified: bool
})

(define-map artisan-collections principal (list 100 uint))
(define-map jewelry-appraisers principal bool)
(define-data-var piece-registry-id uint u0)

;; Error codes
(define-constant err-not-artisan (err u700))
(define-constant err-not-appraiser (err u701))
(define-constant err-piece-not-found (err u702))
(define-constant err-access-restricted (err u403))
(define-constant err-collection-limit-exceeded (err u704))
(define-constant err-invalid-appraiser-principal (err u705))
(define-constant err-invalid-piece-type (err u706))
(define-constant err-invalid-crafting-techniques (err u707))
(define-constant err-invalid-creation-date (err u708))
(define-constant err-invalid-materials-used (err u709))
(define-constant err-invalid-piece-registry-id (err u710))

;; Contract curator for jewelry authentication
(define-constant contract-curator tx-sender)

;; Register jewelry appraiser
(define-public (register-jewelry-appraiser (appraiser principal))
  (begin
    ;; Check if sender is contract curator
    (asserts! (is-eq tx-sender contract-curator) err-access-restricted)
    
    ;; Validate appraiser principal
    (asserts! (not (is-eq appraiser 'SP000000000000000000002Q6VF78)) err-invalid-appraiser-principal)
    
    ;; Add appraiser to registry
    (ok (map-set jewelry-appraisers appraiser true))
  )
)

;; Register jewelry piece
(define-public (register-jewelry-piece 
  (piece-type (string-utf8 64)) 
  (crafting-techniques (string-utf8 256)) 
  (creation-date uint) 
  (materials-used (string-utf8 64)))
  (let
    ((piece-id (var-get piece-registry-id))
     (artisan tx-sender)
     (current-collection (default-to (list) (map-get? artisan-collections artisan))))
    
    ;; Validate inputs
    (asserts! (> (len piece-type) u0) err-invalid-piece-type)
    (asserts! (> (len crafting-techniques) u0) err-invalid-crafting-techniques)
    (asserts! (> creation-date u1600000000) err-invalid-creation-date)
    (asserts! (> (len materials-used) u0) err-invalid-materials-used)
    
    ;; Check collection registration limit
    (asserts! (< (len current-collection) u100) err-collection-limit-exceeded)
    
    ;; Store jewelry piece information
    (map-set jewelry-pieces piece-id {
      artisan: artisan,
      piece-type: piece-type,
      crafting-techniques: crafting-techniques,
      creation-date: creation-date,
      materials-used: materials-used,
      authenticity-verified: false
    })
    
    ;; Update artisan's collection list
    (let 
      ((updated-collection-list (unwrap-panic (as-max-len? (concat (list piece-id) current-collection) u100))))
      (map-set artisan-collections artisan updated-collection-list)
    )
    
    ;; Increment piece registry ID
    (var-set piece-registry-id (+ piece-id u1))
    
    (ok piece-id)))

;; Verify jewelry authenticity
(define-public (verify-jewelry-authenticity (piece-id uint))
  (begin
    ;; Validate piece ID
    (asserts! (< piece-id (var-get piece-registry-id)) err-invalid-piece-registry-id)
    
    (let
      ((jewelry-piece (unwrap! (map-get? jewelry-pieces piece-id) err-piece-not-found)))
      
      ;; Check if sender is jewelry appraiser
      (asserts! (default-to false (map-get? jewelry-appraisers tx-sender)) err-not-appraiser)
      
      ;; Update authenticity verification status
      (ok (map-set jewelry-pieces piece-id (merge jewelry-piece {authenticity-verified: true})))
    )
  )
)

;; Get jewelry piece details
(define-read-only (get-jewelry-piece (piece-id uint))
  (map-get? jewelry-pieces piece-id))

;; Get artisan's collection
(define-read-only (get-artisan-collection (artisan principal))
  (default-to (list) (map-get? artisan-collections artisan)))

;; Check jewelry appraiser status
(define-read-only (is-jewelry-appraiser (address principal))
  (default-to false (map-get? jewelry-appraisers address)))