; Conversion from ASCII Binary to Internal 16-Bit Binary

; Function:
; This routine accepts a binary number from the standard
; input device and converts it to internal 16-bit binary form.

; Input: 
; The individual digits of the binary number are received in
; ASCII through a call to a standard I/O routine. The valid digits are 0
; and 1. An ASCII code other than for a valid digit will terminate the
; routine.

; Output:
; A 16-bit binary number is returned in the DX register.

; Registers used:
; Only DX is modified. It returns the result.

; Segments registered: 
; None

; Routines called: 
; STDIN

; Special notes: 
; None



; ROUTINE TO CONVERT FROM ASCII BINARY TO INTERNAL 16-BIT BINARY
;
bin16in proc    far
;
        push    ax              ; save registers
;
        mov     dx,0            ; initialize DX as 0
;
bin16in1:
        call    stdin           ; digit comes in through AL
        sub     al,30h          ; subtract 30h
        jl      bin16in2        ; check if too low
        cmp     al,1
        jg      bin16in2        ; check if too high
        cbw                     ; convert to word
;
        sal     dx,1            ; shift DX left once
        add     dx,ax           ; add in digit
        jmp     bin16in1
;
bin16in2:
        pop     ax              ; restore registers
        ret                     ; return
;
bin16in endp