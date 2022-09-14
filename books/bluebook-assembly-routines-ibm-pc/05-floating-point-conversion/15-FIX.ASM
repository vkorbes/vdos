; Conversion from Internal Floating Point to 16-Bit Integer

; Function:
; This routine converts from internal single precision binary
; floating point to internal 16-bit signed two's complement integer.

; Input:
; Upon entry a single precision binary floating point is in
; SFPBUFE. The single precision floating point number has a 24-bit binary
; mantissa, a sign bit, and an 8-bit exponent biased by 128.

; Output:
; Upon exit a 16-bit signed two's complement binary number is
; in the DX register.

; Registers used:
; Only DX is modified. It is used for output.

; Segments referenced:
; The data segment contains storage for SFPBUFF

; Routines called:
; None

; Special notes:
; Equates are used to shorten address fields.



; ROUTINE TO CONVERT FROM INTERNAL FLOATING POINT
; TO INTERNAL INTEGER (truncate)
;
fix     proc    far
;
; the number is in sfpbuff
;
        push    cx              ; save registers
        push    ax
;
; get the mantissa
        mov     ax,sfpbuffw0    ; AX gets low part
        mov     dx,sfpbuffw2    ; DX gets high part
        and     dx,007Fh        ; just the mantissa
        or      dx,0080h        ; restore the msb
;
; get the exponent
        mov     cl,sfpbuffb3    ; get the exponent
        mov     ch,0            ; extend to 16-bit
        sub     cx,88h          ; subtract bias+
        cmp     cx,0            ; check its sign
        jl      fix1            ; if negative
        jg      fix3            ; if positive
        je      fix4            ; if zero
;
fix1:
; shift right
        neg     cx              ; absolute value
fix2:
        sar     dx,1            ; shift all bits right
        rcr     ax,1            ; carry on
        loop    fix2
;
        jmp     fix4            ; end of case
;
; shift left
fix3:
        sal     ax,1            ; shift all bits left
        rcl     dx,1            ; carry on
        loop    fix3
;
        jmp     fix4            ; end of case
;
fix4:
; check the sign
        mov     al,sfpbuffb2    ; get sign
        and     al,80h          ; just bit 7
        jz      fix5            ; is it on?
        neg     dx              ; 2's comp if neg
fix5:
        pop     ax              ; restore registers
        pop     cx
        ret                     ; return
;
fix     endp