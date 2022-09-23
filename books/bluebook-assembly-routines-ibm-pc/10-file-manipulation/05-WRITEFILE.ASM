; Write Bytes to a File

; Function:
; This routine writes bytes to a file.

; Input:
; Upon entry BX contains the file's handle, DS:DX points to a
; linear buffer containing the bytes, and CX contains the byte count.

; Output:
; If the bytes are successfully written to the file, the carry is clear,
; and if it is not, the carry is set and the error code is in AX.

; Registers Used:
; No registers are modified. AX and BX are used for
; input and AX is used for output.

; Segments Referenced:
; The data segment must contain the linear byte buffer LBUFF

; Routines Called:
; DOS call number 40h (write to a file) is used.

; Special Notes:
; None.



; ROUTINE TO WRITE A BYTE TO A FILE
;
writefile       proc    far
;
        mov     ah,40h          ; write to file
        int     21h             ; DOS call
        cmp     ax,cx           ; was it all written?
        je      writefile1      ; skip if ok
        mov     ax,21           ; not all bytes were transferred
        stc                     ; set carry if error
;
writefile1
        ret
;
writefile       endp