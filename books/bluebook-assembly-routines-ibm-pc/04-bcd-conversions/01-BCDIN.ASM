; Conversion from ASCII Decimal to BCD

; Function:
; This routine accepts a decimal number from the standard
; input device and converts it to internal BCD format.

; Input: 
; The individual digits of the decimal number are received in
; ASCII through a call to a standard I/0 routine. The valid digits are 0
; through 9. An ASCII code other than for a valid digit will terminate the
; routine.

; Output:
; On return a 36-digit number is stored in BCD form in an 18-
; byte buffer called BCDBUFF.

; Registers used: 
; No registers are modified.

; Segments referenced: 
; DATAS is a data segment which contains BCDBUFF.

; Routines called: 
; STDIN

; Special notes: 
; None



; ROUTINE TO CONVERT FROM ASCII DECIMAL TO INTERNAL BCD FORMAT
;
bcdin   proc    far
;
        push    ds              ; save registers
        push    di
        push    dx
        push    cx
        push    ax
;
; set up data segment
        mov     as,datas        ; point to data segment
        mov     ds,ax
;
; clear bcd buffer
        lea     di,bcdbuff      ; point to BCD buffer
        mov     al,0            ; zero byte
        mov     cx,18           ; buffer size
bcdin1:
        mov     [di],al         ; zero the byte
        inc     di              ; point to next byte
        loop    bcdin1
;
bcdin2:
; get the digit
        call    stdin           ; digit comes in AL
        sub     al,30h          ; subtract 30h
        jl      bcdin4          ; check if too low
        cmp     al,9
        jg      bcdin4          ; check if too high
;
; multiply buffer by 10 and add new digit
        lea     di,bcdbuff      ; point to bcd buffer
        mov     cx,18           ; buffer size
bcdin3:
        push    cx              ; save counter
        mov     dl,al           ; save previous digit
        mov     al,[di]         ; pick up byte from buffer
        mov     cl,4            ; for a count of 4
        sal     ax,cl           ;  shift byte left
        or      al,dl           ; combine with previous digit
        mov     [di],al         ; result goes back
        mov     al,ah           ; prepare for next byte
        and     al,0Fh          ; strip to byte
        inc     di              ; point to next byte
        pop     cx              ; restore count
;
        loop    bcdin3
;
        jmp     bcdin2
;
bcdin4:
        pop     ax              ; restore registers
        pop     cx
        pop     dx
        pop     di
        pop     ds
        ret                     ; return
;
bcdin   endp