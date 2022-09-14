; Conversion from Single Precision to Temporary Floating Point

; Function: 
; This routine converts a single precision binary floating point
; number into a temporary binary floating point number.

; Input:
; Upon entry a single precision floating point number is stored in
; SFPBUFF. The single precision floating point number has a 24-bit binary
; mantissa, a sign bit, and an 8-bit exponent biased by 128.

; Output:
; Upon exit a temporary binary floating point number is stored
; in FPTEMP1. The temporary binary floating point number has a 72-bit
; binary mantissa with 8 bits to the left of these for internal use, a sign
; byte, and a 16-bit two's complement binary exponent.

; Registers used: 
; AX is modified.

; Segments referenced: 
; The data segment contains the variables SFPBUFF
; and FPTEMP1.

; Routines called: 
; None

; Special notes:
; Equates are used to shorten address fields. This is a near
; procedure needed by FPOUT.



; ROUTINE TO CONVERT FROM SINGLE PRECISION FLOATING POINT
; TO TEMP FLOATING POINT
;
sfp2tfp proc    near
;
; clear lower part of mantissa
        mov     fptemp1w0,0     ; clear word
        mov     fptemp1w2,0     ; clear word
        mov     fptemp1w4,0     ; clear word
;
; move rest of mantissa
        mov     ax,sfpbuffw0    ; low 2 bytes
        mov     fptemp1w6,ax    ; put in place
;
        mov     ax,sfpbuffw2    ; high 7 bits
        and     ax,007Fh        ; remove sign
        or      ax,0080h        ; restore msb
        mov     fptemp1w8,ax    ; put in place
;
; move sign
        mov     al,sfpbuffb2    ; in upper byte
        and     al,80h          ; just sign bit
        mov     fptemp1b10,al   ; byte 10 of fptemp1
;
; move exponent
        mov     al,sfpbuffb3    ; byte 3 of sfp
        mov     ah,0            ; make into a word
        sub     ax,80h          ; remove bias
        mov     fptemp1w11,ax   ; its 16-bit 2's comp
;
        ret                     ; return
;
sfp2tfp endp