; Conversion from ASCII Octal to 16-Bit Binary

; Function:
; This routine accepts an octal number from the standard input
; device and converts it to internal 16-bit binary form.

; Input: 
; The individual digits of the octal number are received in ASCII
; through a call to a standard I/O routine. The valid digits are O through
; 7. An ASCII code other than for a valid digit will terminate the routine.

; Output: 
; A 16-bit binary number is returned in the DX register.

; Registers used: 
; Only DX is modified. It returns the result.

; Segments referenced:
; None

; Routines called: 
; STDIN

; Special notes:
; None



; ROUTINE TO CONVERT FROM ASCII OCTAL TO INTERNAL 16-BIT BINARY
;
oct16in proc    far
;
        push    cx              ; save registers
        push    ax
;
        mov     dx,0            ; initialize DX as 0
;
oct16in1:
        call    stdin           ; a digit comes in AL
        sub     al,30h          ; subtract 30h
        jl      oct16in         ; check if too low
        cmp     al,7
        jg      oct16in2        ; check if too high
        cbw                     ; convert to word
;
        mov     cl,3
        sal     dx,cl           ; shift DX left once
        add     dx,ax           ; add in digit
        jmp     oct16in1
;
oct16in2:
        pop     ax              ; restore registers
        pop     cx
        ret                     ; return
;
oct16in endp