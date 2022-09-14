; Standard Output of a Message

; Function:
; This routine sends a message out through the standard
; output device.

; Input:
; Upon input DS:SI points to the message. The message
; terminates with an ASCII zero.

; Output:
; The individual characters of the message are output through
; the standard output device.

; Registers Used:
; No registers are modified. SI is used to point to the
; input.

; Segments Referenced:
; The data segment must contain the message.

; Routines Called: 
; STDOUT

; Special Notes:
; None



; RETURN TO SEND MESSAGE TO STANDARD OUTPUT
;
stdmessout  proc    far
        push    si              ; save registers
        push    ax
;
stdmessout1:
        mov     al,[si]         ; get byte
        inc     si              ; point to next byte
        cmp     al,0            ; done?
        je      stdmessoutexit  ; if so exit
        call    stdout          ; send it out
        jmp     stdmessout1     ; loop for more
;
stdmessoutexit:
        pop     ax              ; restore registers
        pop     si
        ret                     ; return
stdmessout      endp