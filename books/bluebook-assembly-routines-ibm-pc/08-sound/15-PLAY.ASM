; ROUTINE TO PLAY MUSIC
;
play    proc    far
;
        push    ds              ; save registers
        push    si
        push    dx
        push    cx
        push    bx
        push    ax
;
; command pointer is in SI
;
; set the default tempo
        mov     whole,2000      ; 2000 milliseconds for a whole note
;
        cld                     ; forward direction
;
; main loop starts here
play1:
;
; get the command code and go through the cases
play2:
        lodsb                   ; get the byte
;
; End command
        cmp     al,'X'          ; End command?
        jne     play3           
        jmp     playexit
;
; Tempo command
play3:
        cmp     al,'T'          ; Tempo command?
        jne     play4
;
        lodsb                   ; get the tempo
        mov     cl,al           ; set in CX
        mov     ch,0
        mov     ax,60000        ; number of milliseconds per minute
        mov     dx,0            ; upper part is cleared\
        div     cx              ; divide into time
        mov     whole,ax        ; number of milliseconds per whole note
        jmp     play1           ; back for more
;
; Note command
play4:
        cmp     al,'N'          ; Pitch command?
        jne     play5
;
        lodsb                   ; get the pitch
        call    pitch           ; convert
        mov     cx,dx           ; and move result into CX
        call    toneset         ; set the frequency
        call    toneon          ; turn on the tone
;
        mov     cx,whole        ; number of milliseconds per whole note
;
        lodsb                   ; get the duration
        mov     ah,al           ; set up duration as multiplier
        mov     al,0
        sal     cx,1            ; scale factor 1
        mul     cx              ; multiply
;
        mov     cx,dx           ; total count for the note
;
        lodsb                   ; get style
        mov     ah,al           ; set up style as multiplier
        mov     al,0
        mul     cx              ; multiply by style
;
        mov     account,dx      ; store count for note
        sub     cx,dx           ; count for rest
        mov     rcount,cx       ; store count for rest
;
        mov     cx,acount       ; audible part of note
        call    delay           ; delay
        call    toneoff         ; turn off the tone
        mov     cx,rcount       ; inaudible part of note
        call    delay           ; delay
;
        jmp     play1           ; back for more
;
; Rest command
play5:
        cmp     al,'R'          ; Rest command?
        jne     play6
;
        mov     cx,whole        ; number of milliseconds per whole note
;
        lodsb                   ; get the duration
        mov     ah,al           ; set up duration as multiplier
        mov     al,0
        sal     cx,1            ; scale factor of 1
        mul     cx              ; multiply
;
        mov     cx,dx           ; total count
        call    delay           ; delay
;
        jmp     play1           ; back for more
;
; Anything else ends it
play6:
        jmp     playexit        ; stay on exit command
;
playexit:
        pop     ax              ; restore registers
        pop     bx
        pop     cx
        pop     dx
        pop     si
        pop     ds
        ret
;
play    endp
;