; Standard Input with Echo

; Function:
; This routine accepts input from the standard I/O device.

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
; DOS call number 1 (Keyboard input) is used.

; Special Notes:
; None



; ROUTINE FOR STANDARD INPUT WITH ECHO
;
stdin   proc    far
        mov     ah,1        ; standard input
        int     21h         ; DOS call
        ret                 ; return
stdin   endp