; Put a Byte into Circular Buffer

; Function:
; This routine puts one byte into a circular buffer.

; Input:
; Upon entry a byte is in AL.

; Output:
; The byte goes into the circular buffer. The pointers and gauge
; variables are properly adjusted. If the buffer gets nearly full then a
; routine is called to send a signal to the communications device to stop
; sending any more bytes of output.

; Registers Used:
; DI is the buffer pointer and is updated if there is a character.

; Segments Referenced:
; Upon entry the data segment must contain the
; circular buffer and its variables, CBUFF and GAUGE, and the variable
; LASTBYTE.

; Routines Called:
; COMOFF

; Special Notes:
; None.



; ROUTINE TO PUT ONE BYTE INTO A CIRCULAR BUFFER
;
putcbuff        proc    far
;
; put the byte into the buffer
        mov     cbuff[di],al    ; byte goes into buffer
;
; adjust pointer
        inc     di              ; point to next character
        cmp     di,cbuffsize    ; wrap it around?
        jne     putcbuff1       ; skip if no wrap
        mov     di,0            ; wraps back to zero
;
; count it
putcbuff1:
        inc     gauge           ; count the character
        cmp     gauge,nearfull  ; too many characters?
        jne     putcbuff2       ; skip if not
        call    comoff          ; request to stop flow
putcbuff2:
;
putcbuffret:
        ret
;
putcbuff        endp