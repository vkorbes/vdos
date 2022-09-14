; Normalization of Temporary Floating Point

; Function: 
; This routine normalizes temporary binary floating numbers
; that have too large a mantissa.

; Input: 
; Upon entry DS:DI points to a temporary binary floating point
; number whose mantissa is too large.

; Output: 
; Upon exit DS:DI points to a normalized temporary binary
; floating point number.

; Registers used: 
; No registers are modified. DI must point to the number.

; Segments referenced: 
; The data segment must contain the temporary floating number.

; Routines called: 
; None

; Special notes: 
; Equates are used to shorten address fields. This is a near
; procedure needed by FPIN.

; ROUTINE TO NORMALIZE TEMP FLOATING POINT NUMBERS THAT HAVE
; TOO LARGE A MANTISSA
;
ftpnorm proc    near
;
        cmp     diword+8,100h   ; test if too high
        jl      fptnorm1        ; exit if low enough
        sar     diword+8,1      ; shift right all bytes
        rcr     diword+6,1      ; carry on
        rcr     diword+4,1
        rcr     diword+2,1
        rcr     diword+0,1
        inc     diword+11       ; increment exponent
        jmp     fptnorm
;
fptnorm1:       ret             ; return
;
fptnorm endp