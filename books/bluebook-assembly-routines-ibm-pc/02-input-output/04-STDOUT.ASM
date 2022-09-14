; Standard Output

; Function:
; This routine sends individual characters out the standard
; output device.

; Input:
; Upon entry an ASCII code is in AL.

; Output:
; A single character is output through the standard output
; device.

; Registers Used:
; AH is modified. AL, is used for input.

; Segments Referenced:
; None

; Routines Called:
; DOS call number 2 (Display output) is used.

; Special Notes: 
; None



; ROUTINE FOR STANDARD OUTPUT
;
stdout  proc    far
        push    dx          ; save registers
;
        mov     dl,al       ; in DL for DOS call
        mov     ah,2        ; standard output
        int     21h         ; DOS call
;
        pop     dx          ; restore registers
        ret                 ; return
stdout  endp