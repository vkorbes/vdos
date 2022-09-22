; Pseudo-Random Number Generator

; Function:
; This routine generates pseudo-random numbers between 0
; and 1. The numbers are stored in 16-bit binary fixed point notation with
; the binary point on the extreme left.

; Input:
; Upon entry the variable SEED contains a seed value.

; Output:
; Upon exit the seed is updated and the CX register contains a
; pseudo-random number.

; Registers Used:
; Only CX is modified.

; Segments Referenced:
; Upon entry the data segment contains the variable SEED.

; Routines Called:
; None

; Special Notes:
; None



random  proc    far
;
        mov     cx,seed         ; get the seed
        add     cx,9248h        ; add random pattern
        ror     cx,1            ; rotate
        ror     cx,1            ; three
        ror     cx,1            ; times
        mov     seed,cx         ; put it back
;
        ret
;
random  endp