; Direct Standard Output

; Function:
; This routine sends individual characters out the standard
; output device using direct output.

; Input:
; Upon entry an ASCII code is in AL.

; Output:
; A single character is output through the direct standard output
; call.

; Registers Used:
; AH is modified. Al is used for input.

; Segments Referenced:
; None

; Routines Called: 
; DOS call number 6 (Direct console I/O) is used.

; Special Notes:
; None



; ROUTINE FOR DIRECT CONSOLE OUTPUT
;
stdoutdr        proc    far
        push    dx              ; save registers
;
        cmp     al,0FFh         ; check for the one case of input
        je      stdoutrexit
        mov     dl,al           ; in DL for DOS call
        mov     ah,6            ; direct console output
        int     21h             ; DOS call
;
stdoutdrexit:
        pop     dx              ; restore registers
        ret                     ; return
stdoutdr        endp