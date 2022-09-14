; Division of Temporary Floating Point Number by 10

; FUNCTION: 
; This routine divides a temporary binary floating point number by 10.

; Input: 
; Upon entry DS:DI points to a temporary binary floating point number.

; Output: 
; Upon exit DS:DI points to a temporary binary floating point number.

; Registers used: 
; AX, CX, DX, and DI are modified. DI is used to point to the input.

; Segments referenced: 
; The data segment contains a temporary binary floating point number.

; Routines called: 
; None

; Special notes: 
; Equates are used to shorten address fields. This routine is
; needed by FPIN.



; ROUTINE TO DIVIDE TEMP FLOATING POINT NUMBER BY 10 -- RESULT IS
; NOT NORMALIZED
;
fptdiv  proc    near
;
; shift mantissa by 4 places
        mov     cx,4            ; for a count of 4
fptdiv1:
        sal     diword+0,1      ; shift all digits left
        rcl     diword+2,1      ; carry on
        rcl     diword+4,1
        rcl     diword+6,1
        rcl     diword+8,1
        dec     diword+11
        loop    fptdiv1
;
; divide mantissa by 10
        mov     cx,5            ; 5 words in number
        mov     dx,0            ; previous remainder
        add     di,8            ; point to end
;
fptdiv2:
        push    cx              ; save count
        mov     ax,[di]         ; get 16-bit digit
        mov     cx,10           ; divisor of 10
        div     cx              ; divide
        mov     [di],ax         ; put 16-bit digit back
        sub     di,2            ; next 16-bit digit
        pop     cx              ; restore count
        loop    fptdiv2
;
        ret                     ; return
;
fptdiv  endp