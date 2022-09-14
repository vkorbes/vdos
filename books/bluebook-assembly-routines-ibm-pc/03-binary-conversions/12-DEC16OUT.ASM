; Conversion from 16-Bit Binary to ASCII Decimal

; Function:
; This routine accepts a 16-bit binary number in the DX
; register and converts it to ASCII decimal form which is sent to the
; standard output device.

; Input: 
; Upon entry a 16-bit binary number is in the DX register.

; Output: 
; A string of ASCII digits representing a decimal number is
; stored in a buffer called BUFF and then sent out through the standard
; output device.

; Registers used: 
; No registers are modified. DX is used for input.

; Segments referenced: 
; DATAS is a data segment which contains TBUFF.

; Routines called: 
; STDOUT

; Special notes:
; None



; ROUTINE TO CONVERT FROM INTERNAL 16-BIT BINARY TO ASCII DECIMAL
;
dec16out        proc    far
;
        push    ds              ; save registers
        push    di
        push    dx
        push    cx
        push    ax
;
        mov     ax,datas        ; point to data segment
        mov     ds,ax
;
; number is in DX
;
; put the digits in a buffer
;
        mov     cx,0            ; initialize the counter
        lea     di, tbuff       ; point to the buffer
dec16out1:
        push    cx              ; save CX
        mov     ax,dx           ; numerator
        mov     dx,0            ; clear upper half
        mov     cx,10           ; divisor of 10
        div     cx              ; divide
        xchg    ax,dx           ; get quotient
;
        add     al,30h          ; add 30h
        mov     [di],al         ; put in buffer
        inc     di              ; next byte
;
        pop     cx              ; restore CX for the count
        inc     cx              ; count the digit
        cmp     dx,0            ; done?
        jnz     dec16out1
;
; dump the buffer out
;
dec16out2:
        dec     di              ; back up through the buffer
        mov     al,[di]         ; get byte from buffer
        call    stdout          ; send it out
        loop    dec16out2
;
        pop     ax              ; restore registers
        pop     cx
        pop     dx
        pop     di
        pop     ds
        ret                     ; return
;
dec16out        endp