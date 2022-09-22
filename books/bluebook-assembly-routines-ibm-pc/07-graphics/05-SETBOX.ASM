; Fill a Rectangular Box with Color

; Function:
; This routine fills a rectangular box in the color graphics
; screen with a given color:

; Input: 
;     Upon entry:
;     x-coordinate of upper left corner is in x1
;     y-coordinate of upper left corner is in v1
;     ×-coordinate of lower right corner is in x2
;     y-coordinate of lower right corner is in y2
;     color of the rectangle is in bits 0 and 1 of color

; Output: 
; Just to the screen.

; Registers Used: 
; No registers are modified.

; Segments Referenced:
; Upon entry ES must point to the video RAM at
; B8000h and DS must point to the following look-up table for color
; masks:

;     xtable  dw  OFFCOh, OFFFOh, OFFFCh, OFFFFh
;             dw  03FCOh. 03FFOh, 03FFCh, 03FFFh
;             dw  00FCOh, 00FFOh, 00FFCh, 00FFFh
;             dw  003C0h, 003F0h, 003FCh, 003FFh

; Routines Called:
; None

; Special Notes:
; No bounds checking is performed. The coordinates must
; be in range and in order. That is, the following must be true:

;     0 <= x1 <= x2 <= 319
;     0 <= y1 <= y2 <= 199



; ROUTINE TO FILL A RECTANGULAR BOX
;
setbox  proc    far
;
        push    si              ; save registers
        push    di
        push    dx
        push    bx
        push    cx
        push    ax
;
; determine byte position for start
;
; get y contribution
        mov     ax,y1           ; get starting y-coordinate
        mov     ah,al           ; replicate for odd/even bank
        and     ax,1FEh         ; just one bit gets moved
        sal     ax,1            ; times 4
        sal     ax,1            ; times 8
        sal     ax,1            ; times 16
        mov     di,ax           ; address gets 16 times y-coordinate
        and     di,7FFh         ; not the odd/even bit
        sal     ax,1            ; times 32
        sal     ax,1            ; times 64
        add     di,ax           ; address gets 80 times y-coordinate
;
; add in x contribution
        mov     ax,x1           ; get x-coordinate
        sar     ax,1            ; divide
        sar     ax,1            ;  by 4
        add     di,ax           ; beginning offset
;
; count for outer loop
        mov     cx,y2           ; ending y-coordinate
        sub     cx,y1           ; minus starting y-coordinate
        inc     cx              ; plus one
;
; count for inner loop 
        mov     si,x2           ; ending x-coordinate
        sar     si,1            ; divide
        sar     si,1            ;  by 4
        mov     ax,x1           ; starting x-coordinate
        sar     ax,1            ; divide
        sar     ax,1            ;  by 4
        sub     si,ax           ; take the difference
;
; get the color
        mov     bx,color        ; get the color
        and     bx,3            ; just between 0 and 3
        mov     dl,cbytes[bx]   ; look up color pattern
;
; determine mask for start and ending bytes
        mov     bx,x1           ; starting byte
        and     bx,3            ; just the pixel position
        sal     bx,1            ; times 2
        sal     bx,1            ; times 4
        mov     ax,x2           ; ending byte
        and     ax,3            ; just the pixel position
        add     bx,ax           ; 4*starting+ending
        sal     bx,1            ; 8*starting+2*ending
        mov     bx,xtable[bx]   ; look up the masks
;
; set up masked color bytes
        mov     dh,dl           ; color for left bytes
        mov     ah,dl           ; color for middle bytes
        and     dx,bx           ; mask left and right color bytes
;
        cld                     ; forward
;
sboxloop:
        push    cx              ; save count of outer loop
        push    di              ; save initial byte position
;
        mov     cx,si           ; count for inner loop
;
; check for only one byte
        mov     al,bh           ; get the mask
        jcxz    sboxloop2       ; if ending byte coincides
;
; color leftmost byte of the scan line
        not     al              ; reverse the mask for clearing
        and     al,es:[di]      ; get byte from memory and clear pixels
        or      al,dh           ; put color in place
        stosb                   ; put byte in place
;
; check for just two bytes
        dec     cx              ; count the byte
        jcxz    sboxloop1       ; done?
;
; color middle bytes of the scan line
        mov     al,ah           ; color for middle bytes
        rep     stosb           ; put middle bytes in place
;
; handle rightmost byte of the scan line
;
; come here if two or more bytes
sboxloop1:
        mov     al,0FFh         ; set full mask
;
; in any case come here to adjust the masks
sboxloop2:
        and     al,bl           ; bring in right part of mask
        and     dl,al           ; clear left part of color if needed
;
; color the byte
        not     al              ; reverse the mask for clearing
        and     al,es:[di]      ; get byte from memory and clear pixels
        or      al,dl           ; put pixels in the byte
        stosb                   ; put byte back into video RAM
;
; compute next scan line
        pop     di              ; restore address of left side of box
        test    di,2000h        ; odd or even line?
        jz      sboxloop3       ; skip if even
        add     di,80           ; add 80 bytes per line
sboxloop3:
        xor     di,2000h        ; changes banks in any case
        pop     cx              ; restore count for outer loop
        loop    sboxloop        ; next scan line
;
        pop     ax              ; restore registers
        pop     cx
        pop     bx
        pop     dx
        pop     di
        pop     si
        ret
;
setbox  endp