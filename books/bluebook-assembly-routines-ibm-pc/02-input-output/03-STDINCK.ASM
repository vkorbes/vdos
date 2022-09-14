; Standard Input Check

; Function: This routine checks, but does not wait for input from the
; standard I/O device.

; Input:
; Input is from the standard I/O device. No check is made for
; (CtrI) (Break)

; Output:
; If a character is available, the routine returns with the flag
; condition N and the character in AL, but if no character is available
; then the routine returns with the flag condition Z, and AL is
; meaningless. No echo generated for the input characters.

; Registers Used:
; AH is modified. AL is used for output.

; Segments Referenced: 
; None

; Routines Called: 
; DOS call number 06h (Direct console I/O) is used.

; Special Notes:
; None



; ROUTINE TO CHECK FOR STANDARD INPUT
;
stdinck proc    far
        push    dx          ; save registers
;
        mov     dl,0FFh     ; direct console input
        mov     ah,06h      ; check standard direct input status
        int     21h         ; DOS call
;
        pop     dx          ; restore registers
        ret                 ; return
stdinck endp