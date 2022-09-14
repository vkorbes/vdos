; Conversion from External to Internal Floating Point

; Function: 
; This routine accepts an ASCII decimal floating number from
; a standard input device and converts it to internal binary floating point.

; Input: 
; The characters of the floating point number are received in
; ASCII through a call to a standard input routine. The decimal floating
; point number has an optional sign, followed by decimal digits of the
; mantissa with one embedded decimal point. Following the mantissa is an
; option exponent which starts with the letter E, then an optional sign,
; then a decimal number. It is possible to get erroneous results if the
; number is too large or small to be stored as a single precision binary
; floating point number.

; Output:
; Upon exit a single precision binary floating point number is in
; SFPBUFF. The single precision floating point number has a 24-bit binary
; mantissa, a sign bit, and an 8-bit exponent biased by 128.

; Registers used:
; No registers are modified.

; Segments referenced: 
; The data segment contains the variables FPTEMP1, FPTEMP2, and SFPBUFF.

; Routines called: 
; STDIN, FPINDIGIT, FPTMUL, FPTDIV, and FPTNORM

; Special notes: 
; Equates are used to shorten address fields.



; ROUTINE TO CONVERT FROM ASCII EXTERNAL TO INTERNAL FLOATING POINT
;
fpin    proc    far
;
        push    di              ; save registers
        push    si
        push    dx
        push    cx
        push    ax
;
; clear fp temp1 buffer
        lea     di,fptemp1      ; point to fptemp1
        mov     al,0            ; digit = 0
        call    fpindigit       ; store digit

; clear the decimal flag and the count
        mov     decflag,0       ; clear flag
        mov     decexp,0        ; clear decimal exponent
;
; look for the sign
        call    stdin           ; look for sign
        cmp     al,'-'          ; minus
        jz      fpin1           ; store it
        cmp     al,'+'          ; plus
        jz      fpin2           ; ignore it
        jmp     fpin3           ; anything else gets used
;
fpin1:
; set sign as negative
        mov     fptemp1b10,80h  ; put sign in place
;
fpin2:
        call    stdin           ; get next digit
fpin3:
        cmp     al,'.'          ; check for decimal place
        jne     fpin4           ; go on if not
;
; set decimal flag
        cmp     decflag,0       ; decimal flag already set?
        jne     fpin5           ; exit if not the first
        mov     decflag,0FFh    ; set it now
        jmp     fpin2           ; go back for a digit
;
fpin4:
        sub     al,30h          ; subtract 30h
        jl      fpin5           ; too low?
        cmp     al,9            
        jg      fpin5           ; too high?
        jmp     fpin6           ; got a digit
;
fpin5:
        jmp     fpin15          ; end of mantissa
;
; load digit as a floating point number
fpin6:
        lea     di,fptemp2      ; point to fptemp2
        call    fpindigit       ; put in the digit
;
; multiply result by 10
        lea     di,fptemp1      ; point to fptemp1
        call    fptmul          ; multiply by 10
;
; pick one with larger exponent
        mov     cx,fptemp1w11   ; get sign of fptemp1
        sub     cx,fptemp2w11   ; subtract sign of fptemp2
        je      fpin11          ; skip if equal
        jg      fpin9           ; if exp fptemp2 is less
;
fpin7:
; exponent of fptemp1 is less than exponent of fptemp2
        neg     cx              ; absolute value of exp
fpin8:
; shift the bits
        sar     fptemp1w8,1     ; shift all bits right
        rcr     fptemp1w6,1     ; carry on
        rcr     fptemp1w4,1
        rcr     fptemp1w2,1
        rcr     fptemp1w0,1
        loop    fpin8
;
; set the exponent
        mov     ax,fptemp2w11   ; get exp of fptemp2
        mov     fptemp1w11,ax   ; put in exp of fptemp1
;
        jmp     fpin11          ; done with this case
;
fpin9:
;
; exponent of fptemp2 is less than exponent of fptemp1
;
fpin10:
; shift the bits
        sar     fptemp2w8,1     ; shift all bits right
        rcr     fptemp2w6,1
        rcr     fptemp2w4,1
        rcr     fptemp2w2,1
        rcr     fptemp2w0,1
        loop    fpin10
;
; set the exponent
        mov     ax,fptemp1w11   ; get exp of fptemp1
        mov     fptemp2w11,ax   ; put in exp of fptemp2
;
        jmp     fpin11          ; end of this case
;
fpin11:
;
; add the digit to the result
;
        mov     cx,5            ; for a count of 5 words
        lea     di,fptemp1      ; di points to fptemp1
        lea     si,fptemp2      ; si points to fptemp2
        clc
fpin12:
        mov     ax,[si]         ; get 16-bit digit from fptemp1
        inc     si              ; point to next 16-bit digit
        inc     si
        adc     [di],ax         ; add to 16-bit digit of fptemp2
        inc     di              ; point to next 16-bit digit
        inc     di
        loop    fpin12
;
; normalize
        lea     di,fptemp1      ; point to fptemp1
        call    fptnorm         ; renormalize it
;
fpin13:
;
; decrement decimal exponent if dec flag is on
        cmp     decflag,0       ; check decimal flag
        je      fpin14          ; skip if not set
        dec     decexp          ; dec exponent if set
;
fpin14:
        jmp     fpin2           ; go back for next digit
;
fpin15:
; adjust for the decimal point
        add     al,30h          ; restore ASCII
        and     al,5Fh          ; upper or lower case
        cmp     al,'E'          ;is it E for exponent?
        jne     fpin16
;
; grab exponent
;
        call    sgndec16in      ; get decimal exponent
        cmp     cx,0            ; check its sign
        jg      fpin17          ; if positive
        jl      fpin18          ; if negative
;
; zero count
        jmp     fpin20          ; done if exponent is zero
;
; positive decimal exponent
fpin17:
        push    cx              ; save count = decimal exponent
;
; multiply result by 10
        lea     di,fptemp1      ; point to fptemp1
        call    fptmul          ; multiply by 10
;
; normalize
        lea     di,fptemp1      ; point of fptemp1
        call    fptnorm         ; renormalize it
;
        pop     cx              ; restore the count
        loop    fpin17
;
        jmp     fpin20          ; end of this case
;
fpin18:
; negative count
        neg     cx              ; absolute value of exponent
fpin19:
        push    cx              ; save the count = exponent
;
; divide mantissa by 10
        lea     di,fptemp1      ; point to fptemp1
        call    fptdiv          ; divide by 10
;
; normalize
        lea     di,fptemp1      ; point to fptemp1
        call    fptnorm         ; renormalize it
;
        pop     cx              ; restore the count
        loop    fpin19
;
fpin20:
        call    tfp2sfp         ; convert to single precision
;
        pop     ax              ; restore registers
        pop     cx
        pop     dx 
        pop     si
        pop     di
        ret                     ; return
;
fpin    endp