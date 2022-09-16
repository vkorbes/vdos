; Plot a Point on the Medium Resolution Color Screen

; Function:
; This routine plots a point on the medium resolution color
; graphics screen. The pixel at the specified location is given a specified
; color, overwriting the old color.

; Input: 
;    Upon entry:
;    ×-coordinate (0-319) of the point is in SI
;    y-coordinate (0-199) of the point is in DI
;    color (0-3) is in DX

; Output: 
; Just to the screen.

; Registers Used: 
; No registers are modified. SI, DI, and DX are used for input.

; Segments Referenced: 
; Upon entry ES must point to the video RAM at
; B8000h and DS must point to a data segment containing the following
; look-up table of rotated color masks:

;     ctable  dw  0003Fh. 0403Fh. 0803Fh. OCO3Fh
;             dw  000CFh, 010CFh, 020CFh, 030CFh
;             dw  000F3h. 004F3h. 008F3h. 00CF3h
;             dw  000FCh, 001FCh, 002FCh. 003FCh

; Routines Called:
; None

; Special Notes: 
; No bounds checking is performed. The user must make
; sure that the coordinates and the color are in their proper ranges.



; ROUTINE TO PLOT A POINT ON MEDIUM RES COLOR SCREEN
;
setpt   proc    far
;
        push    bx              ; save registers
        push    si
        push    ax
;
; multiply y-coord by bytes per row and adjust for even/odd lines
        mov     ax,di           ; get y-coord into low part
        mov     ah,al           ;  and into high part
        and     ax,01FEh        ; mask off unwanted parts
        sal     ax,1            ; times 4
        sal     ax,1            ; times 8
        sal     ax,1            ; times 16
        mov     bx,ax           ; goes into address
        and     bh,7            ; without adjustment
        sal     ax,1            ; times 32
        sal     ax,1            ; times 64
        add     bx,ax           ; address gets y-coord times 80
;
; add x-coord to address
        mov     ax,si           ; get x-coordinate
        sar     ax,1            ; divide
        sar     ax,1            ; by 4
        add     bx,ax           ; here is the address
;
; compute the rotated mask and color
        and     si,3            ; just pixel position into the index
        sal     si,1            ; index times 2
        sal     si,1            ; index times 4
        add     si,dx           ; 4*pixel position + color
        sal     si,1            ; 8*pixel position + 2*color
        mov     ax,ctable[si]   ; look up rotated color and mask
;
; insert the color into the video byte
        and     al,es:[bx]      ; get old byte & remove old pixel
        or      al,ah           ; insert new color
        mov     es:[bx],al      ; put the byte back
;
        pop     ax              ; restore registers
        pop     si
        pop     bx
        ret
;
setpt   endp