; Output from Circular Buffer

; Function:
; This routine handles output from a circular buffer. It checks
; to see if there are enough bytes in the buffer to send to disk. If there are
; not enough then it returns without further action. If there are enough
; then it sends a block of bytes to an opened file through the WRITEFILE
; routine.

; Input:
; Upon entry BX contains the file handle of the output file. Input
; is from the circular buffer.

; Output:
; Output is to a file. If the buffer gets nearly empty then a
; control Q is sent to the standard output device. If the write was
; unsuccessful the carry is set and the error code is returned. If a control Z
; detected from the circular buffer the carry is set and error code 19
; id of file) is returned.

; Registers Used:
; Only AX and SI are modified. AX contains the
; exception code, SI is the buffer pointer and is updated according to the
; characters taken. BX is the file handle for the output file.

; Segments Referenced:
; Upon entry the data segment must contain the
; circular buffer and its variables, CBUFF and GAUGE, and the variable
; LASTBYTE.

; Routines Called:
; COMOFF, FLUSHIT

; Special Notes:
; None



; ROUTINE TO HANDLE OUTPUT FROM A CIRCULAR BUFFER
;
outcbuff        proc    far
;
; check for enough characters in the buffer
        cmp     gauge,blksize   ; any characters?
        jl      outcbuffexit    ; exit if no characters
;
; empty the buffer
        call    comoff          ; hold the com line
        call    flushit         ; flush the buffer
        jc      outcbuffret     ; error?
;
outcbuffexit:
        clc                     ; clear carry - no exception
outcbuffret:
        ret
;
outcbuff        endp