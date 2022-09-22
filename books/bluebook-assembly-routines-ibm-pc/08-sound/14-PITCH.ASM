; ROUTINE TO DETERMINE PITCH
;
pitch   proc    far
;
        push    cx              ; save registers
        push    bx
        push    ax
;
        mov     ah,0            ; extend pitch number to 16 bits
        mov     cl,12           ; divisor of 12
        div     cl              ; divide
;
        mov     dl,al           ; quotient determines the octave
        mov     al,ah           ; remainder is the pitch within
        cbw                     ; 16-bit needed for look up
        sal     ax,1            ; 2 bytes per item
        mov     bx,ax           ; into BX
        mov     cx,notes[bx]    ; look it up
        call    freq            ; convert the frequency
;
        xchg    cx,dx           ; octave in cl, period in DX
        neg     cl              ; 8 - octave = shift count
        add     cl,8            
        sal     dx,cl
;
        pop     ax              ; restore registers
        pop     bx
        pop     cx
        ret
;
pitch   endp