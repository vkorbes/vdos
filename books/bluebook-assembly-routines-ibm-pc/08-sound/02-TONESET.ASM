; Set the Tone on the Speaker

; Function:
; This routine selects the frequency of the square wave tone to
; the speaker. The input to this routine is a 16-bit integer n which
; determines the frequency f according to the following formula:
;     f=F/n
; where F is 1,193,182, the frequency of a clock signal which feeds the
; timer. The value n is the number of cycles of the clock signal per cycle of
; the resulting square wave. This routine does not actually turn on the
; tone. Use TONEON to turn the tone on and TONEOFF to turn it off.
; This routine assumes that the speaker timer has already been properly
; initialized. This happens during normal boot-up of the computer, or you
; can use TONEINIT to initialize this timer.

; Input:
; Upon entry the 16-bit integer n is in the CX register.

; Output:
; Only to the timer 2.

; Registers Used: 
; No registers are modified.

; Segments Referenced:
; None

; Routines Called:
; None

; Special Notes:
; None



; ROUTINE TO SELECT TONE
;
toneset proc    far
;
        push    ax              ; save registers

; load the time period into the timer
        mov     al,cl           ; lower byte
        out     42h,al          ; out to timer
        mov     al,ch           ; upper byte
        out     42h,al          ; out to timer
;
        pop     ax              ; restore registers
        ret
;
toneset endp