; Conversion from Internal to External Floating Point

; Function: 
; This routine displays a single precision floating point number
; on the standard output device as a decimal floating point number.

; Input: 
; Upon entry a single precision binary floating point number is in
; SFPBUFE. The single precision floating point number has a 24-bit binary
; mantissa, a sign bit, and an 8-bit exponent biased by 128.

; Output: 
; The individual characters of a decimal floating number are sent
; out through the standard output device. The decimal floating point
; number has a sign character which is blank or minus, followed by
; decimal digits of the mantissa with one embedded decimal point to the
; right of the first significant digit. Following the mantissa is an exponent
; which starts with the letter E, then a sign, then a decimal number.

; Registers used: 
; AX, CX, BX, DX, SI, and DI are modified.

; Segments referenced:
; The data segment contains storage for the variables
; DECBUFF, DECSIGN, DECEXP, FPTEMP1, and SFPBUFF.

; Routines called: 
; STDOUT, SFP2TFP, DECHALF, DECDOUBLE, DECNORM, TDECSHOW.

; Special notes: 
; Equates are used to shorten address fields.



; ROUTINE TO CONVERT FROM INTERNAL FLOATING POINT
; TO ASCII FLOATING POINT
;
fpout   proc    far
;
        push    di              ; save registers
        push    si
        push    dx
        push    bx
        push    cx
        push    ax
;
; check for zero as a special case
        mov     ax,sfpbuffw0    ; get low word
        or      ax,sfpbuffw2    ; get high word
        jnz     fpout1          ; go on if not zero
;
        mov     al,'0'          ; make a zero
        call    stdout          ; send it out
        jmp     fpout6          ; and exit
;
fpout1:
; convert from single precision to temp floating point
        call    sfp2tfp         ; convert to temp format
;
; initialize exponent for unnormed position
        mov     decexp,21       ; exp = 21 for start
;
; set the sign
        mov     al,fptemp1b10   ; get sign
        mov     decsign,al      ; put it away
;
; convert mantissa to a decimal string
        lea     si,fptemp1      ; si points to fptemp1
        lea     di,decbuff      ; di points to decbuff
        call    bin802dec       ; make decimal string
;
; check sign of binary exponent
        mov     cx,fptemp1w11   ; get the binary exp
        sub     cx,72           ; biased by -72
        cmp     cx,0            ; check its sign
        jl      fpout2          ; if negative
        jg      fpout4          ; of positive
        jmp     fpout5          ; if zero
;
fpout2:
; binary exponent is negative
        neg     cx              ; absolute value of exp
;
fpout3:
        push    cx              ; save count = binary exp
;
; divide by 2
        lea     di,decbuff      ; point to decbuff
        call    dechalf         ; divide by 2
;
; normalize
        lea     di,decbuff      ; point to decbuff
        call    decnorm         ; renormalize
;
        pop     cx              ; restore count
        loop    fpout3      
;
        jmp     fpout5          ; end of case
;
; binary exponent is positive
;
fpout4:
        push    cx              ; save count = binary exp
;
; multiply by 2
        lea     di,decbuff      ; point to decbuff
        call    decdouble       ; multiply by 2
;
; normalize
        lea     di,decbuff      ; point to decbuff
        call    decnorm         ; renormalize
;
        pop     cx              ; restore count
        loop    fpout4
;
        jmp     fpout5          ; end of case
;
fpout5:
; output the number
        call    tdecshow        ; display the number
;
fpout6:
        pop     ax              ; restore registers
        pop     cx
        pop     bx      
        pop     dx
        pop     si
        pop     di
        ret                     ; return
;
fpout   endp