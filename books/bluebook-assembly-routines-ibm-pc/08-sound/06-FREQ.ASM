; Conversion from Frequency to Period

; Function:
; This routine converts from frequency to the number required
; by TONESET to set the frequency. The routine performs the following
; formula:
;     n = F/f
; where f is the frequency input to this routine, n is the number output by
; this routine, and F is 1,193,182. In other words this routine divides the
; specified frequency f into the 1,193,182 hertz clock frequency that drives
; the timer. Use this routine just before TONESET.

; Input:
; Upon entry the frequency is in CX.

; Output:
; Upon exit F/f is in CX.

; Registers Used:
; Only CX is modified.

; Segments Referenced:
; None

; Routines Called:
; None

; Special Notes:
; None



; ROUTINE TO CONVERT FROM FREQUENCY TO PERIOD
;
freq    proc    far
;
        push    dx              ; save registers
        push    ax
;
        mov     dx,12h          ; upper part of numerator
        mov     ax,34DEh        ; lower part of numerator
        div     cx              ; divide by frequency
        mov     cx,ax           ; the quotient is the output
;
        pop     ax              ; restore registers
        pop     dx
        ret
;
freq    endp