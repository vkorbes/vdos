; White Noise

; Function:
; This routine makes white noise of a given frequency range.

; Input:
; Upon entry the lower limit to the frequency is in BX, the upper
; limit to the frequency is in CX, and a measure of the duration of the
; noise is in DX. This last value is just the number of times that the
; frequency is changed while the routine runs.

; Output: 
; To the speaker and timer only.

; Registers Used: 
; No registers are modified.

; Segments Referenced:
; The data segment must contain the variables xl
; and x2.

; Routines Called: 
; TONESET, TONEON, TONEOFF

; Special Notes:
; The speaker timer must alreadv have been initialized.
; This should happen during boot-up or TONEINIT may be used.



; ROUTINE TO MAKE WHITE NOISE
;
white   proc    far
;
        push    dx                  ; save registers
        push    cx
        push    ax
;
        mov     x1,bx               ; lower limit of frequencies
        mov     x2,cx               ; upper limit of frequencies
;
        mov     seed,0              ; initialize seed
        call    freq                ; convert the frequency
        call    toneset             ; set the frequency
        call    toneon              ; turn the tone on
;
        mov     cx,dx               ; get the number of times
white1:
        push    cx                  ; save count
        call    random              ; generate a random number (0-1)
        call    scale               ; scale between x1 and x2
        call    freq                ; convert the frequency
        call    toneset             ; set the tone
        pop     cx                  ; restore count
        loop    white1
;
; turn off the tone
        call    toneoff             ; turn it off
;
        pop     ax                  ; restore registers
        pop     cx
        pop     dx
        ret
;
white   endp