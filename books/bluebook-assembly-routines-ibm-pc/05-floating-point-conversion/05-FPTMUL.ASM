; Multiplication of Temporary Floating Point Number by 10

; Function:
; A temporary binary floating number is multiplied by 10. The
; result is not normalized

; Input: 
; Upon entry DS:DI points to a temporary binary floating point
; number.

; Output: 
; Upon exit DS:DI points to a temporary binary floating point
; number. This number is not normalized.

; Registers used: 
; AX, CX, DX, and DI are modified. DI is used to point to
; the input.

; Segments referenced: 
; The data segment contains the temporary binary
; floating point number.

; Routines called: 
; None

; Special notes: 
; This is a near routine needed by FPIN.



; ROUTINE TO MULTIPLY TEMP FLOATING POINT BY 10
;
fptmul  proc    near
;
        mov     cx,5            ; for a count of 5
        mov     dx,0            ; carry of zero
fptmul1:
        push    cx              ; save count
        mov     ax,dx           ; previous carry
        xchg    ax,[di]         ; switch with 16-bit digit
        mov     cx,10           ; multiplier of 10
        mul     cx              ; multiply
        add     [di],ax         ; add into carry in place
        add     di,2            ; next 16-bit digit
        pop     cx              ; restore count
        loop    fptmul1
;
        ret                     ; return
;
fptmul  endp