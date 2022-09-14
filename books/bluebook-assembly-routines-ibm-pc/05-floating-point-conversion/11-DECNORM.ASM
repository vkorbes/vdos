; Normalization of Temporary Decimal Floating Point

; Function:
; This routine normalizes a temporary decimal floating point number.

; Input: 
; Upon entry DS:DI points to a temporary decimal floating point number.

; Output: 
; Upon exit the temporary floating point number is normalized.

; Registers used: 
; AX, CX, and DI are modified.

; Segments referenced: 
; The data segment contains storage for a temporary
; decimal floating point number.

; Routines called: 
; None

; Special notes: 
; Equates are used to shorten address fields.



; ROUTINE TO NORMALIZE TEMPORARY DECIMAL FLOATING POINT NUMBER
;
decnorm proc    near
;
; check top+1 digit
        cmp     dibyte+22,0     ; is it already zero?
        je      decnorm2        ; if so exit
;
; round up starting with bottom digit
        mov     al,[di]         ; first digit
        add     al,al           ; double it for rounding
        mov     ah,0            ; prepare carry
        aaa                     ; adjust for decimal
;
; now shift the rest
        mov     cx,24           ; for a count of 24
decnorm1:
        mov     al,[di+1]       ; get next digit
        add     al,ah           ; add carry
        mov     ah,0            ; prepare next carry
        aaa                     ; adjust for decimal
        mov     [di],al         ; put digit in place
        inc     di              ; point to next digit
        loop    decnorm1
;
        inc     decexp          ; increment decimal exponent
;
decnorm2:
        ret                     ; return
;
decnorm endp