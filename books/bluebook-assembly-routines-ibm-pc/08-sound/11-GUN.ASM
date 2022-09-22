; Machine Gun

; Function:
; This routine makes a machine gun noise.

; Input:
; None

; Output:
; To the speaker and timer only.

; Registers Used:
; No registers are modified.

; Segments Referenced:
; The data segment must contain the variables xl and x2.

; Routines Called:
; WHITE, DELAY

; Special Notes:
; The speaker timer must already have been initialized.
; This happens during boot-up.



; ROUTINE TO MAKE MACHINE GUN SOUND
;
gun     proc    far
;
        push    dx              ; save registers
        push    cx
        push    bx
;
        mov     cx,10
gun1:
        push    cx              ; save the count
        mov     bx,256          ; lower limit of frequencies
        mov     cx,4096         ; upper limit of frequencies
        mov     dx,256          ; controls length
        call    white           ; use white noise for gun
        mov     cx,50           ; 400 millisecond
        call    delay           ; delay
        pop     cx              ; restore the count
        loop    gun1
;
        pop     bx              ; restore registers
        pop     cx
        pop     dx
        ret
;
gun     endp