; Conversion from 80-Bit Binary to Decimal Digits

; Function: 
; This routine converts an 80-bit binary integer into a decimal
; string.

; Input:
; Upon entry SI points to an 80-bit binary integer to be used as
; input and DI points to a 25-digit decimal string to be used as output.

; Output: 
; Upon exit a 25-digit decimal string is where DI pointed upon
; entry. DI still points there upon exit.

; Registers used: 
; AX, BX, CX, DX, and SI are modified. DI is used to
; point to the output, but is preserved.

; Segments referenced:
; The data segment contains storage for the 80-bit
; binary number (10 bytes) and the 25-digit decimal number (25 bytes).

; Routines called: 
; None

; Special notes:
; This is a near procedure needed by FPOUT.



; ROUTINE TO CONVERT 80-BIT BINARY NUMBER INTO A DECIMAL STRING
;
bin802dec       proc    near
;
; clear the string
        push    di              ; save destination pointer
;
        mov     al,0            ; zero byte
        mov     cx,25           ; for a count of 25
bin802dec1:
        mov     [di],al         ; zero the byte
        inc     di              ; point to next byte
        loop    bin802dec1
;
        pop     di              ; restore destination pointer
;
; loop forever
;
bin802dec2:
        push    si              ; save source pointer
;
; divide mantissa by 10
        mov     bx,0            ; done flag
        mov     cx,5            ; 5 words in number
        mov     dx,0            ; previous remainder
        add     si,8            ; point to high end
;
bin802dec3:
        push    cx              ; save count
        mov     ax,[si]         ; get 16-bit digit
        mov     cx,10           ; divisor of 10
        div     cx              ; divide
        mov     [si],ax         ; put 16-bit digit back
        or      bx,ax           ; check for zero
        sub     si,2            ; point to next 16-bit digit
        pop     cx              ; restore count
        loop    bin802dec3
;
        mov     [di],dl         ; remainder is decimal digit
        inc     di              ; point to next decimal digit
;
        pop     si              ; restore source pointer
        cmp     bx,0            ; was the binary zero?
        jnz     bin802dec2      ; loop if nonzero
;
        ret                     ; return
bin802dec       endp