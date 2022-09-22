; Print a String on the Graphics Screen

; Function:
; This routine prints a message on the graphics screen, using
; the SCHAR or RCHAR routines above. The message terminates in a
; zero.

; Input:
;     Upon entry:
;     address of message is in SI
;     x-coordinate of upper left corner of string is in xmess
;     y-coordinate of upper left corner of string is in ymess
;     horizontal magnitude of characters is in xmagn
;     vertical magnitude of characters is in ymagn
;     color of characters is in color
;     choice of fonts (0 = stroke,1 = raster) is in font

; Output: 
; Just to the screen.

; Registers Used:
; No registers are modified.

; Segments Referenced:
; Upon entry ES must point to the video RAM at
; B8000h and DS must point to the data segment used by the point-
; plotting, box-filling, line-drawing, and stroke character routines.

; Routines Called:
; RCHAR and SCHAR

; Special Notes:
; No bounds checking is performed. Unpredictable results
; happen if the horizontal or vertical magnitude is too large.



; ROUTINE TO PRINT A MESSAGE ON THE GRAPHICS SCREEN
;
gmessout        proc    far
;
; get (x,y) location of a message on the screen
        mov     ax,xmess        ; get x-coordinate on screen
        mov     x0,ax           ; for first character
        mov     ax,ymess        ; get y-coordinate on screen
        mov     y0,ax           ; for first character
        cld                     ; go in forward direction
;
; main loop through characters of the message
gmessloop:
        cld                     ; forward direction
        lodsb                   ; get the ASCII code
        cmp     al,0            ; end of string?
        je      gmessexit
;
; check for fonts
font0:
        cmp     font,0          ; use font 0?
        jne     font1
        call    schar           ; stroke characters
;
font1:
        cmp     font,1          ; use font1?
        jne     nextchar
        call    rchar           ; raster characters
;
nextchar:
        mov     al,8            ; character cell width
        mov     cl,xmagn        ; times horizontal magnitude
        mul     cl              ; multiply
        add     x0,ax           ; add to location of previous char
;
        jmp     gmessloop       ; loop for next character
;
gmessexit:
        ret
gmessout        endp