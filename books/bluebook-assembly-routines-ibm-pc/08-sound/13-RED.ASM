; Red Alert

; Function: 
; This routine makes a red alert sound consisting of ten rapid
; upward glissandos.

; Input:
; None

; Output:
; To the speaker and timer only.

; Registers Used: 
; No registers are modified.

; Segments Referenced: 
; The data segment must contain the variables xl and x2.

; Routines Called: 
; GLISSANDO

; Special Notes:
; The speaker timer must already have been initialized.
; This should happen during boot-up.



; ROUTINE TO MAKE RED ALERT
;
red     proc    far
;
        push    dx              ; save registers
        push    cx
        push    bx
;
        mov     cx,10           ; ten glissandos
red1:
        push    cx              ; save the counter
        mov     bx,256          ; starting frequency
        mov     cx,4096         ; ending frequency
        mov     dx,1            ; delay factor
        call    glissando       ; now make the glissando
        pop     cx              ; restore the loop count
        loop    red1
;
        pop     bx              ; restore registers
        pop     cx
        pop     dx
        ret
;
red     endp