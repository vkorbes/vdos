; Create a File

; Function:
; This routine creates a file for read/write. If a file already
; exists, then its length is truncated to zero, ready to be written to.

; Input:
; Upon entry DS:DX points to an ASCIIZ string with the drive,
; path, and filename.

; Output: 
; If the file can be opened, the carry is clear and its handle is
; returned in AX. If it cannot be opened, the carry is set and an error
; code is returned in AX.

; Registers Used:
; Only AX is modified. DX is used for input and AX is used for output.

; Segments Referenced:
; Upon entry the data segment must contain the ASCII string.

; Routines Called:
; DOS call number 3Ch (CREAT) is used.

; Special Notes:
; None.



; ROUTINE TO CREATE A FILE
;
createfile      proc    far
;
        push    cx              ; save registers
;
        mov     cx,0            ; attribute 0
        mov     ah,3Ch          ; create file
        int     21h             ; DOS call
;
        pop     cx              ; restore registers
        ret
;
createfile      endp