; ROUTINE TO FILL AN AREA
;
; preliminary push and pop procedures
;
; pushpaint pushes x- and y-coordinates on paint stack
pushpaint       proc    near
        dec     bp              ; BP is the paint stack pointer
        dec     bp              ; and gets decremented first
        mov     [bp],si         ; push x
        dec     bp
        dec     bp
        mov     [bp],di         ; push y
        ret                     ; return
;
pushpaint       endp
;
; poppaint pops x- and y-coordinates on paint stack
poppaint        proc    near
        mov     di,[bp]         ; pop y
        inc     bp              ; increment stack after
        inc     bp
        mov     si,[bp]         ; pop x
        inc     bp
        inc     bp
        ret
poppaint        endp
;
paint   proc    far
;
; initialize paint color
        mov     dx,color
;
; initialize paint stack
        lea     bp,paintstack   ; BP is set to top of stack
        call    pushpaint       ; push seed onto stack
;
; main loop for painting
paint1:
        lea     ax,paintstack   ; stack empty?
        cmp     bp,ax
        jne     paint2          ; continue if not
        jmp     endpaint        ; exit if not
;
; get the next place to paint
paint2:
        call    poppaint        ; pop the next place to paint
        call    locate          ; color is returned in AL
        cmp     al,dl           ; is it filled?
        je      paint1
        cmp     al,dh           ; is it boundary?
        je      paint1          
        cmp     di,0            ; top of screen?
        jl      paint1
        cmp     di,199          ; bottom of screen?
        jg      paint1
;
; move right until boundary is reached
paint3:
        inc     si              ; x = x+1
        call    locate          ; look right
        dec     si              ; restore x
;
        cmp     al,dl           ; is it filled?
        je      paint4          
        cmp     al,dh           ; is it boundary color?
        je      paint4
        cmp     si,319          ; at right screen boundary?
        je      paint4  
        inc     si              ; x = x+1
        jmp     paint3
;
; push above and below
paint4:
        dec     di              ; y = y-1
        call    locate          ; check above
        mov     bh,al           ; save above state
        cmp     al,dl           ; is it filled?
        je      paint5
        cmp     al,dh           ; is it boundary color?
        je      paint5
        call    pushpaint       ; push above
paint5:
        inc     di              ; restore y
        inc     di              ; y = y+1
        call    locate          ; check below
        mov     bl,al           ; save below state
        cmp     al,dl           ; is it filled?
        je      paint6
        cmp     al,dh           ; is it boundary color?
        je      paint6
        call    pushpaint       ; push below
;
paint6:
        dec     di              ; restore y
;
; anchor the end point of the scan line
        mov     x2,si           ; store x-coord of end of scan line
        mov     y2,di           ; store y-coord of end of scan line
;
; plot as we scan left, checking above and below
;
paint7:
; check above
        dec     di              ; y - y-1
        call    locate          ; check above
;
        cmp     al,dl           ; is it filled?
        je      paint9          
        cmp     al,dh           ; is it boundary color?
        je      paint9
;
        cmp     bh,dl           ; last above filled?
        je      paint8
        cmp     bh,dh           ; was it boundary color?
        je      paint8
        jmp     paint9
;
paint8:
        call    pushpaint       ; push above if new place to paint
;
paint9:
        mov     bh,al           ; update last above
;
        inc     di              ; restore y
;
; check below
        inc     di              ; y = y+1
        call    locate          ; check below
        cmp     al,dl           ; is it filled?
        je      paint11
        cmp     al,dh           ; is it boundary color?
        je      paint11
;
        cmp     bl,dl           ; last below filled?
        je      paint10
        cmp     bl,dh           ; was it boundary color?
        je      paint10
        jmp     paint11
;
paint10:
        call    pushpaint       ; push below if new place to paint
paint11:
        dec     di              ; restore y
        mov     bl,al           ; update last below
;
; move left
        dec     si              ; x = x-1
        jl      paint12         ; stop the scan if too far left
        call    locate          ; check the point
        cmp     al,dl           ; hit filled yet?
        je      paint12         ;  if so next scan line
        cmp     al,dh           ; hit boundary yet?
        je      paint12         ; if so next scan line
        jmp     paint7          ; continue painting the scan line
paint12:
        inc     si              ; restore x
        mov     x1,si           ; store x-coordinate of start
        mov     y1,di           ; store y-coordinate of start
        call    setbox          ; plot the scan line
        jmp     paint1          ; next place to paint
;
endpaint:
        ret
;
paint   endp