; Close a File

; Function:
; This routine closes a file.

; Input:
; Upon entry BX contains the file handle of the file that is to be closed.

; Output:
; If the file can be closed, the carry is clear. If it cannot be
; closed, the carry is set and an error code is returned in AX.

; Registers Used: 
; Only AX is modified. BX is used for input and AX is used for output.

; Segments Referenced: 
; None.

; Routines Called: 
; DOS call number 3Eh (close file) is used.

; Special Notes:
; None.



; ROUTINE TO CLOSE A FILE
;
closefile       proc    far
;
        mov     ah,3Eh          ; close a file
        int     21h             ; DOS call
        ret
;
closefile       endp