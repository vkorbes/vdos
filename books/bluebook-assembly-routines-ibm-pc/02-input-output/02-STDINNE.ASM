; Standard Input with No Echo

; Function:
; This routine accepts input from the standard I/O device. No
; echo is generated.

; Input:
; This routine waits for one character code from the standard
; input device.

; Output:
; ASCII codes are returned in the AL register. Each character is
; echoed out the standard output device as it is input through the standard
; input device.

; Registers Used:
; AH is modified. AL is used for output.

; Segments Referenced:
; None

; Routines Called:
; DOS call number 8 (Console input without echo) is
; used.

; Special Notes:
; None



; ROUTINE FOR STANDARD INPUT WITHOUT ECHO
;
stdinne proc    far
        mov     ah,8        ; standard input without echo
        int     21h         ; DOS call
        ret                 ; return
stdinne endp