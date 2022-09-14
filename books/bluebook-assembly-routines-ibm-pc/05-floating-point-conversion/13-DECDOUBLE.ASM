; Doubling a Temporary Decimal Floating Point Number

; Function: 
; This routine multiplies a temporary decimal floating point
; number by two.

; Input: 
; Upon entry DS:DI points to a temporary decimal floating point
; number.

; Output: 
; Upon exit the number has been doubled.

; Registers used: 
; AX, CX, and DI are modified.

; Segments referenced: 
; The data segment contains storage for the
; temporary decimal floating point number.

; Routines called: 
; None

; Special notes: 
; This is a near procedure needed by FPOUT.



; ROUTINE TO MULTIPLY TEMPORARY DECIMAL NUMBER BY 2 - RESULT NOT NORMED
;
decdouble       proc    near
;
        mov     cx,25           ; for a count of 25
        mov     ah,0            ; clear previous carry
decdouble1:
        mov     al,[di]         ; get digit
        sal     al,1            ; multiply by 2
        add     al,ah           ; add the carry
        aam                     ; adjust for decimal multiplication
        mov     [di],al         ; put back the byte
        inc     di              ; point to next byte
        loop    decdouble1
;
        ret                     ; return
;
decdouble       endp