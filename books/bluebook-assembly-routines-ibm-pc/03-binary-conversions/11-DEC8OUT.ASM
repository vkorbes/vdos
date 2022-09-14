; Conversion from 8-Bit Binary to ASCII Decimal

; Function:
; This routine accepts an 8-bit binary number in the DL
; register and converts it to ASCII decimal form which is sent to the
; standard output device.

; Input:
; Upon entry an 8-bit binary number is in the DL register.

; Output:
; A string of ASCII digits representing a decimal number is
; stored in a buffer called BUFF and then sent out through the standard
; output device.

; Registers used: 
; No registers are modified. DL is used for input.

; Segments referenced: 
; DATAS is a data segment which contains TBUFF

; Routines called: 
; STDOUT

; Special notes: 
; None



; ROUTINE TO CONVERT FROM INTERNAL 8-BIT BINARY TO ASCII DECIMAL
;
dec8out proc    far
;
        push    ds                  ; save registers
        push    di
        push    dx
        push    cx
        push    ax
;
        mov     ax,datas            ; point to the data segment
        mov     ds,ax
;
; a binary number is in DL
;
; put the digits in a buffer
;
        mov     cx,0                ; initialize a counter
        mov     di, offset tbuff    ; point to buffer
dec8out1:
        push    cx                  ; save CX
        mov     al,dl               ; AX has a numerator
        mov     ah,0                ; clear upper half
        mov     cl,10               ; divisor of 10
        div     cl                  ; divide
        mov     dl,al               ; get quotient
        mov     al,ah               ; get remainder
;
        add     al,30h              ; add 30h
        mov     [di],al             ; put in buffer
        inc     di                  ; point to next byte
;
        pop     cx                  ; restore CX
        inc     cx                  ; count the digit
        cmp     dl,0                ; done?
        jnz     dec8out1
;
; dump the buffer out
;
dec8out2:
        dec     di                  ; back up through the buffer
        mov     al,[di]             ; get the byte from the buffer
        call    stdout              ; send it out
        loop    dec8out2
;
        pop     ax                  ; restore registers
        pop     cx
        pop     dx
        pop     di
        pop     ds
        ret                         ; return
;
dec8out endp