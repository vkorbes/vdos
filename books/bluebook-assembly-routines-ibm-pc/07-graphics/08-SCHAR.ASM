; ROUTINE TO PLOT A STROKE CHARACTER
;
schar   proc    far
;
        push    si              ; save registers
        push    cx  
        push    ax
;
        cbw                     ; make the ASCII code into 16-bit
        sal     ax,1            ; times 2
        mov     si,ax           ; into the index
        mov     si,ptable[si]   ; look up the particular character
        mov     ax,x0           ; x-coordinate of upper left corner
        mov     x2,ax           
        mov     ax,y0           ; y-coordinate of upper left corner
        mov     y2,ax
;
; run through the strokes
newstroke:
        lodsb                   ; get the code byte
        cmp     al,1ah          ; end of strokes?
        jz      scharexit      
        mov     dl,al           ; save code
;
; update x-coordinate of current position
        mov     ax,x2           ; old x-coordinate
        mov     x1,ax           ; gets pushed back
        lodsb                   ; new x-coordinate
        mov     cl,xmagn        ; times xmagn
        mul     cl              ; multiply
        add     ax,x0           ; add to upper left corner
        mov     x2,ax           ; and put into current position
;
; update y-coordinate of current position
        mov     ax,y2           ; old y-coordinate
        mov     y1,ax           ; gets pushed back
        lodsb                   ; new y-coordinate
        mov     cl,ymagn        ; times ymagn
        mul     cl              ; multiply
        add     ax,y0           ; add to upper left corner
        mov     y2,ax           ; put in current position
;
        cmp     dl,'U'          ; pen up?
        je      newstroke       ; skip if so
;
        call    setline         ; draw the stroke
;
        jmp     newstroke       ; next stroke
;
scharexit:
        pop     ax              ; restore registers
        pop     cx
        pop     si
        ret
;
schar   endp