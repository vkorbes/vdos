; ROUTINE TO CONVERT FROM TEMP FLOATING POINT TO SINGLE PRECISION
; FLOATING POINT
;
tfp2sfp proc    near
;
; move mantissa
        mov     ax,fptemp1w4    ; below word
        rcl     ax,1            ; carry for round up
        mov     ax,fptemp1w6    ; low word
        adc     ax,0            ; low word + carry
        mov     sfpbuffw0,ax    ; put in place
        mov     dx,ax           ; check for zero
;
        mov     ax,fptemp1w8
        or      dx,ax           ; check this part too
        and     ax,007Fh        ; just bottom 7 bits
        mov     sfpbuffw2,ax    ; put in place
;
; move sign bit
        mov     al,fptemp1b10   ; byte 10 is sign
        and     al,80h
        or      sfpbuffb2,all   ; bit 7 is sign
;
; move exponent
        mov     ax,fptemp1w11   ; 16-bit 2's complement exponent
        cmp     ax,-128         ; too low?
        jl      tfp2sfp2        ; error message
        cmp     ax,127          ; too high?
        jg      tfp2sfp3        ; error message
;
        add     ax,80h          ; bias
        cmp     dx,0            ; was mantissa 0?
        jne     tfp2sfp1
        mov     al,0            ; then -128 exponent
tfp2sfp1:
        mov     sfpbuff3,al     ; put biased byte back
;
; normal return
;
; show hex for debugging
        lea     si,internal     ; point to message
        call    stdmessout      ; send message
;
        mov     dx,sfpbuffw2    ; upper word
        call    hex16out        ; show it
;
        mov     dx,sfpbuffw2    ; lower word
        call    hex16out        ; show it
;
        call    stdspace        ; skip space
        clc                     ; clear carry
        ret                     ; return
;
; underflow error
tfp2sfp2:
        lea     si,underflow    ; point to message
        jmp     tfp2sfp4
;
; overflow error
tfp2sfp3:
        lea     si,overflow     ; point to message
        jmp     tfp2sfp4
;
tfp2sfp4:
        call    stdmessout      ; send message
        stc                     ; set carry
        ret                     ; return
;
tfp2sfp endp