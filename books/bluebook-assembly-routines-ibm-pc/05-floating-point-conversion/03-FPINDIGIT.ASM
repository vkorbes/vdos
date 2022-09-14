; Single Decimal Digit to Floating Point

; Function: 
; A single decimal digit is placed in temporary binary floating
; point format.

; Input: 
; Upon entry AL contains the value of the digit.

; Output:
; Upon entry and exit the address of the temporary binary
; floating point result is in DI.

; Registers used: 
; AL, CX, and DI are modified.

; Segments referenced:
; Upon entry the data segment contains storage for
; the temporary binary floating point number.

; Routines called: 
; None

; Special notes: 
; This is a near procedure needed by FPIN.



; ROUTINE TO PLACE DIGIT IN TEMP FLOATING POINT
;
fpindigit       proc    near
;
; clear the number first
        push    di              ; save pointer
        push    ax              ; save digit
        mov     al,0            ; zero byte
        mov     cx,13           ; do 13 bytes
fpindigit1:
        mov     [di],al         ; clear the byte
        inc     di              ; point to next byte
        loop    fpindigit1      ; loop for more
        pop     ax              ; restore digit
        pop     di              ; restore pointer
;
; move the digit into place
        mov     [di+9],al       ; place the digit
;
        ret                     ; return
;
fpindigit       endp