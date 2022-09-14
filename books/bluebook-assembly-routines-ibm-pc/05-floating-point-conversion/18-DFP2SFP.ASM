; Conversion from Double to Single Precision

; Function:
; This routine converts an internal double precision binary
; Apating point number to an internal single precision floating point
; number.

; Input:
; Upon entry a double precision binary floating point number is
; in DEPBUFE. The double precision floating point number has a 40-bit
; binary mantissa, a sign bit, and an 8-bit exponent biased by 128.

; Output:
; Upon exit a single precision binary floating point number is in
; SEPBUFF. The single precision floating point number has a 24-bit binary
; mantissa, a sign bit, and an 8-bit exponent biased by 128.

; Registers used:
; No registers are modified.

; Segments referenced:
; The data segment contains storage for the
; variables SFPBUFF and DFPBUFF.

; Routines called:
; None

; Special notes:
; Equates are used to shorten address fields.



; ROUTINE TO CONVERT FROM INTERNAL DOUBLE PRECISION
; TO INTERNAL SINGLE PRECISION FLOATING POINT
;
dfp2sfp proc    far
;
        push    ax              ; save registers
;
        mov     ax,dfpbuffw4    ; get word from double precision
        mov     sfpbuffw0,ax    ; place in single precision
;
        mov     ax,dfpbuffw6    ; get word from double precision
        mov     sfpbuffw2,ax    ; place in single precision
;
        pop     ax              ; restore registers
        ret                     ; return
;
dfp2sfp endp