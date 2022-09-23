; Input to Circular Buffer

; Function:
; This routine handles input to a circular buffer. It checks to
; see if there is any input from a serial communications line. If there is
; input then it is sent to a circular buffer. If a control Z is received then
; carry is set and an exception code is returned. If there is no input then it
; returns with the carry clear and without further action.

; Input:
; Upon entry DX specifies the communications line (0 = com1:
; and 1 = com2:). During the routine input is from COMINCK routine.

; Output:
; The input characters go to the circular buffer. If the buffer
; gets nearly full then a routine is called to send a signal to the
; communications device to stop sending any more bytes of output. If a
; control Z is detected from the communications line the carry is set and an
; exception code is returned.

; Registers Used:
; DI is the buffer pointer and is updated if there is a character.

; Segments Referenced:
; Upon entry the data segment must contain the
; circular buffer and its variables, CBUFF and GAUGE, and the variable
; LASTBYTE.

; Routines Called:
; COMON, COMOFE, COMINCK, PUTCBUFF

; Special Notes:
; None.



; ROUTINE TO HANDLE INPUT FOR CIRCULAR BUFFER
;
incbuff proc    far
;
; check for a character
        call    cominck         ; check for character
        jz      incbuffexit     ; good exit if none
;
; strip off parity bit
        and     al,7Fh          ; just 7 bits
;
; check for linefeed
        cmp     al,10           ; ASCII 10 is linefeed
        jne     incbuff1        ; skip if not linefeed
        cmp     lastbyte,13     ; was last byte a carriage return?
        je      incbuff2        ; skip if cr/lf
;
incbuff1:
        call    putcbuff        ; put byte into buffer
        mov     lastbyte,al     ; update last byte
;
; check for carriage return and
incbuff2:
        cmp     al,13           ; ASCII 13 is carriage return
        jne     incbuff3        ; skip if not
;
; also put a linefeed if character was a carriage return
        push    ax              ; save current character
        mov     al,10           ; put a linefeed
        call    putcbuff        ; into buffer
        pop     ax              ; restore current character
;
; check for end of file
incbuff3:
        cmp     al,controlz     ; end of file?
        je      incbuff5        ; is an exception
;
; check for overflow
        cmp     gauge,nearfull  ; too many characters?
        jl      incbuff4        ; skip if not
        call    comoff          ; request to stop flow
        jmp     incbuffexit     ; good exit
;
; if not overflow make sure flow is on
incbuff4:
        call    comon           ; make sure flow is on
        jmp     incbuffexit     ; good exit
;
; handle end of file exception
incbuff5:
        mov     ax,19           ; end of file code
        stc                     ; set carry for error
        jmp     incbuffret      ; return with error
;
incbuffexit:
        clc                     ; clear carry - no error
;
incbuffret:
        ret
;
incbuff endp