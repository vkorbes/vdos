; Halving a Temporary Decimal Floating Point Number

; Function: 
; This routine divides a temporary decimal floating point
; number by two.

; Input: 
; Upon input DI points to a temporary decimal floating point
; number.

; Output:
; Upon exit the number has been divided by two. The result is
; not normalized.

; Registers used: 
; AX, CX, and DI are modified.

; Segments referenced: 
; The data segment contains a temporary decimal
; floating point number.

; Routines called: 
; None

; Special notes:
; This is a near procedure needed by FPOUT.



; ROUTINE TO DIVIDE TEMPORARY DECIMAL NUMBER BY 2 - RESULT NOT NORMED
;
dechalf proc    near
;
; first shift up one digit
        mov     cx,25           ; for a count of 25
        mov     al,0            ; zero previous digit
dechalf1:
        xchg    al,[di]         ; exchange with current digit
        inc     di              ; point to next digit
        loop    dechalf1
;
        dec     decexp          ; decrement decimal digit
;
; now divide by 2
        mov     cx,25           ; for a count of 25
        mov     ah,0            ; clear
dechalf2:
        push    cx              ; save count
        dec     di              ; point to next digit
        mov     al,[di]         ; get the digit
        mov     cl,2            ; divisor of 2
        aad                     ; adjust for division
        div     cl              ; divide
        mov     [di],al         ; put back
        pop     cx              ; restore count
        loop    dechalf2
;
        ret                     ; return
;
dechalf endp