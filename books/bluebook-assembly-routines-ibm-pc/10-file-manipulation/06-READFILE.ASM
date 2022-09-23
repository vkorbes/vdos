; Read Bytes from a File

; Function:
; This routine reads bytes from a file.

; Input:
; Upon entry BX contains the file's handle, CX contains the count,
; and DS:DX points to a linear buffer where the bytes are to appear.

; Output:
; If the bytes are successfully read from the file, the carry is
; clear, and if it is not, the carry is set and the error code is returned in AL.

; Registers Used: 
; No registers are modified. CX, DX, and BX are used for input.

; Segments Referenced:
; The data segment must contain the linear byte buffer LBUFF.

; Routines Called: 
; DOS call number 3Fh (read from a file) is used.

; Special Notes:
; None.



; ROUTINE TO READ BYTES FROM A FILE
;
readfile        proc    far
;
        mov     ah,3Fh          ; read from a file
        int     21h             ; DOS call
;
        cmp     ax,cx           ; everything back?
        je      readfileexit    ; skip if ok
        mov     ax,22           ; not all read
        stc                     ; set carry for error
;
readfileexit:
        ret
;
readfile        endp