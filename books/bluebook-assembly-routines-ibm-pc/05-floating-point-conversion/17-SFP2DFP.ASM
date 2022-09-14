; Conversion from Single to Double Precision

; Function:
; This routine converts an internal single precision binary
; floating point number to an internal double precision floating point
; number.

; Input:
; Upon entry a single precision binary floating point number is in
; SFPBUFE. The single precision floating point number has a 24-bit binary
; mantissa, a sign bit, and an 8-bit exponent biased by 128.

; Output:
; Upon exit a double precision binary floating point number is in
; DEPBUFE. The double precision floating point number has a 40-bit
; binary mantissa, a sign bit, and an 8-bit exponent biased by 128.

; Registers used:
; No registers are modified.

; Segments referenced:
; The data segment contains storage for the
; variables SFPBUFF and DFPBUFF.

; Routines called:
; None

; Special notes:
; Equates are used to shorten address fields.



; ROUTINE TO CONVERT FROM INTERNAL SINGLE PRECISION
; TO INTERNAL DOUBLE PRECISION FLOATING POINT
;
sfp2dfp proc    far
;
        push    ax              ; save registers
;
; clear low part of mantissa
        mov     dfpbuffw0,0     ; clear low word
        mov     dfpbuffw2,0     ; clear next low word
;
; move rest of number
        mov     ax,sfpbuffw0    ; get word from single precision
        mov     dfpbuffw4,ax    ; put in double precision
;
        mov     ax,sfpbuffw2    ; get word from single precision
        mov     dfpbuffw6,ax    ; put in double precision
;
        pop     ax              ; restore registers
        ret                     ; return
;
sfp2dfp endp