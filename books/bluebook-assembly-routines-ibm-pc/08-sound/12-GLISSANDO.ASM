; Make a Glissando

; Function:
; This routine makes a glissando, that is, a sound which slides
; from one frequency to another. The rate of change can be controlled.

; Input:
; Upon entry the beginning frequency is in BX, the ending
; Frequency is in CX, and the control parameter for the rate increase is in
; DX. Increasing the value in DX slows down the rate of change.

; Output:
; To the speaker and timer only.

; Registers Used:
; No registers are modified.

; Segments Referenced:
; The data segment must contain the variables xl and x2.

; Routines Called:
; TONESET, TONEON, TONEOFF, DELAY

; Special Notes:
; The speaker timer must already have been initialized. If
; necessary, use TONEINIT to initialize the speaker timer before calling
; this routine.



; ROUTINE TO MAKE GLISSANDO
;
glissando       proc    far
;
        push    si              ; save registers
        push    dx
        push    cx
        push    bx
        push    ax
;
        mov     x1,bx           ; lower limit of frequencies
        mov     x2,cx           ; upper limit of frequencies
;
        call    toneon          ; turn on tone

; set up the loop parameters
        mov     si,1            ; increment for loop
        cmp     bx,cx           ; up or down?
        jle     gliss1          ; skip if up
;
        neg     si              ; decrement freq in the loop
;
gliss1:
        mov     cx,bx           ; get the frequency
        call    freq            ; convert to clock cycles
        call    toneset         ; set the tone
        mov     cx,dx           ; delay parameter
gliss2:
        loop    gliss2

        cmp     bx,x2           ; check if done
        je      gliss3          ; exit if so
        add     bx,si           ; update the frequency
;
        jmp     gliss1
;
gliss3:
; turn off the tone
        call    toneoff         ; turn it off
;
        pop     ax              ; restore registers
        pop     bx
        pop     cx
        pop     dx
        pop     si
        ret
;
glissando       endp