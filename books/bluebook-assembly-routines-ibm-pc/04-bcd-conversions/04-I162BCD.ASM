; Conversion from 16-Bit Binary to BCD

; Function:
; This routine converts internal 16-bit binary numbers to
; numbers stored in internal BCD format.

; Input: 
; Upon entry a 16-bit binary number is in the DX register.

; Output: 
; On return a 36-digit number is stored in BCD form in an 18-
; byte buffer called BCDBUFF.

; Registers used: 
; No registers are modified. DX is used for input.

; Segments referenced: 
; DATAS is a data segment containing BCDBUFE.

; Routines called: 
; None

; Special notes: 
; None



; ROUTINE TO CONVERT FROM INTERNAL 16-BIT BINARY TO INTERNAL BCD
;
i162bcd proc    far
;
        push    ds              ; save registers
        push    di
        push    dx
        push    cx
        push    ax
;
; set up data segment
        mov     ax,datas        ; point to data segment
        mov     ds,ax
;
; a binary number is in DX
;
; clear bcd buffer
        lea     di,bcdbuff      ; point to buffer
        mov     al,0            ; zero byte
        mov     cx,18           ; buffer size
i162bcd1:
        mov     [di],al         ; clear byte
        inc     di              ; next byte
        loop    i162bcd1
;
; put the digits in a buffer
        lea     di,bcdbuff      ; point to buffer
i162bcd2:
        mov     ax,dx           ; numerator
        mov     dx,0            ; clear upper half
        mov     cx,10           ; divisor of 10
        div     cx              ; divide
        xchg    ax,dx           ; get quotient
        mov     bl,al           ; save digit
;
        mov     ax,dx           ; numerator
        mov     dx,0            ; clear upper half
        mov     cx,10           ; divisor of 10
        div     cx              ; divide
        xchg    ax,dx           ; get quotient
;
        mov     cl,4            ; for a count of 4
        rol     al,cl           ;  rotate digit
        and     al,0F0h         ; just the digit
        or      al,bl           ; combine digits
;
        mov     [di],al         ; put in buffer
        inc     di              ; next byte
        cmp     dx,0            ; done?
        jnz     i162bcd2
;
        pop     ax              ; restore registers
        pop     cx          
        pop     dx
        pop     di
        pop     ds
        ret                     ; return
;
i162bcd endp