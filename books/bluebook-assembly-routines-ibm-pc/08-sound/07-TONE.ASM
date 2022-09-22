; Make a Tone

; Function:
; This routine makes a tone of a given frequency and given length.

; Input:
; Upon entry the frequency is in CX and the length in number of
; milliseconds is in DX.

; Output:
; To the speaker and timer only.

; Registers Used: 
; No registers are modified.

; Segments Referenced:
; The data segment must contain the variable COUNT.

; Routines Called: 
; TONESET, TONEON, TONEOFF, DELAY

; Special Notes:
; The speaker timer must already have been properly
; initialized. This should happen during boot-up.



; ROUTINE TO MAKE TONE
;
tone    proc    far
;
        push    dx              ; save registers
        push    cx
        push    ax
;
; compute the frequency and set up the tone
        call    freq            ; convert the frequency
        call    toneset         ; set up the tone
;
; turn on the tone
        call    toneon          ; turn it on
;
; wait for proper delay
        mov     cx,dx           ; get delay length
        call    delay
;
; turn off the tone
        call    toneoff         ; turn it off
;
        pop     ax              ; restore registers
        pop     cx
        pop     dx
        ret
;
tone    endp