; Flush the Circular Buffer

; Function:
; This routine flushes all bytes from a circular buffer, sending
; them to a specified file.

; Input:
; Upon entry BX contains the file handle of the output file.
; During the routine, input is from the circular buffer.

; Output:
; Output is to a file whose handle is in BX.

; Registers Used:
; Only AX and SI are modified. AX contains the
; exception code, SI is the buffer pointer and is updated to reflect the
; characters taken. BX is the file handle for the output file.

; Segments Referenced:
; Upon entry the data segment must contain the
; circular buffer and its variables, CUFF and GAUGE, the variable
; LASTBYTE, and the linear buffer LBUFF.

; Routines Called:
; WRITEFILE

; Special Notes:
; None.



; ROUTINE TO FLUSH A CIRCULAR BUFFER
;
flushit proc    far
;
        push    di              ; save registers
        push    dx
        push    cx
;
; get the bytes from the buffer
        mov     cx,gauge        ; get the count
        jcxz    flushitexit     ; check for empty
        mov     di,0            ; initialize destination
;
; loop to get all the bytes
flushit1:
        mov     al,cbuff[si]    ; get the character
        inc     si              ; increment the pointer
        cmp     si,cbuffsize    ; wrap it?
        jne     flushit2        ; skip if no wrap
        mov     si,0            ; wrap the buffer pointer
;
flushit2:
        mov     lbuff[di],al    ; put the byte in linear buffer
        inc     di
        loop    flushit1        ; loop until all bytes in lbuff
;
; send the linear buffer to the disk
        mov     cx,gauge        ; this is the number of bytes
        lea     dx,lbuff        ; this is where they are
        call    writefile       ; send them out
        mov     gauge,0         ; set circular buffer empty
;
flushitexit:
        pop     cx              ; restore registers
        pop     dx
        pop     di
        ret
;
flushit endp