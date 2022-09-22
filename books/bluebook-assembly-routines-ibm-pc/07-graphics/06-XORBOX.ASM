; XOR Fill a Rectangular Box with Color

; Function: 
; This routine fills a rectangular box in the color graphics
; screen with a given color using the "exclusive or" operation. Each pixel in
; the rectangle is colored with a color obtained by "exclusive oring" its
; original color with a specified color. This function is useful for making
; cursors.

; Input:
;     Upon entry:
;     ×-coordinate of upper left corner is in x1
;     y-coordinate of upper left corner is in vl
;     x-coordinate of lower right corner is in x2
;     y-coordinate of lower right corner is in y2
;     color of the rectangle is in bits 0 and 1 of color

; Output: 
; Just to the screen.

; Registers Used: 
; No registers are modified.

; Segments Referenced:
; Upon entry ES must point to the video RAM at
; B8000h and DS must point to the following look up table for color
; masks:

;     xtable  dw      OFFCOh, OFFFOh, OFFFCh, OFFFFh
;             dw      03FCOh, 03FFOh, 03FFCh, 03FFFh
;             dw      00FCOh, 00FFOh, 00FFCh, OOFFEh
;             dw      003c0h. 003F0h. 003FCh, 003FFh

; Routines Called:
; None

; Special Notes:
; No bounds checking is performed. The coordinates must
; be in range and in order. That is, the following must be true:

;     0 <= x1 <= x2 <= 319
;     0 <= y1 <= y2 <= 199



; ROUTINE TO XOR A RECTANGULAR BOX
;
xorbox  proc    far
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
        cld                     ; forward direction
;
xboxloop:
        push    cx              ; save count for outer loop
        push    di              ; save address of leftmost byte
;
        mov     cx,si           ; count for inner loop
;
; check if only one byte in a scan line
        mov     al,bh           ; get the mask
        jcxz    xboxloop3       ; ending byte coincides
;
; xor the leftmost byte
        xor     es:[di],dh      ; xor color into memory
        inc     di              ; next byte
        dec     cx              ; count it
        jcxz    xboxloop2       ; done?
;
; xor the middle bytes
xboxloop1:
        xor     es:[di],ah      ; xor color byte into memory
        inc     di              ; next byte
        loop    xboxloop1       ; loop to get all the middle
;
; handle the rightmost byte
;
; come here if two or more bytes
xboxloop2:
        mov     al,0FFh         ; set full mask
;
; in any case come here to adjust
xboxloop3:
        and     al,bl           ; bring in right part
        and     dl,al           ; mask the color if needed
;
; xor the rightmost byte
        xor     es:[di],dl      ; xor byte into memory
        inc     di              ; next byte
;
        pop     di              ; restore the leftmost address
        test    di,2000h        ; odd or even scan line?
        jz      xboxloop4       ; skip if even
        add     di,80           ; add 80 if odd
xboxloop4:
        xor     di,2000h        ; switch banks in any case
        pop     cx              ; restore count of outer loop
        loop    xboxloop        ; loop for next scan line
;
        pop     ax              ; restore registers
        pop     cx
        pop     bx
        pop     dx
        pop     di
        pop     si
        ret
;
xorbox  endp