; XOR a Point onto the Medium Resolution Color Screen

; Function:
; This routine plots a point on the medium resolution screen
; using the "exclusive or" operation. The pixel at the specified location is
; colored with a color obtained by "exclusive oring" its original color with a
; specified color. This function is useful for making cursors.

; Input: 
;     Upon entry:
;     ×-coordinate (0-319) of the point is in SI
;     y-coordinate (0-199) of the point is in DI
;     color mask (0-3) for or is in DX

; Output: 
; Just to the screen.

; Registers Used: 
; No registers are modified. SI, DI, and DX are used for input.

; Segments Referenced:
; Upon entry ES must point to the video RAM at
; B8000h and DS must point to a data segment containing the following
; look-up table for rotated color masks:


; ctable  dw  0003Fh. 0403Fh. 0803h. OCo3h
;         dw  000CFh, 010CFh, 020CFh, 030CFh
;         dw  000F3h, 004F3h, 008F3h, 00CF3h
;         dw  000FCh, 001FCh, 002FCh, 003FCh

; Routines Called:
; None

; Special Notes:
; No bounds checking is performed. The user must make
; sure that the coordinates and the color are in their proper ranges.



; ROUTINE TO XOR A POINT ONTO MEDIUM RES COLOR SCREEN
;
xorpt   proc    far
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
; compute the mask for color and use it
        and     si,3            ; just the bit count into the index
        sal     si,1            ; index times 2
        sal     si,1            ; index times 4
        add     si,dx           ; 4*pixel position + color
        sal     si,1            ; 8*pixel position + 2*color
        mov     ax,ctable[si]   ; look up the masks
        xor     es:[bx],ah      ; xor the byte with the color
;
        pop     ax              ; restore registers
        pop     si
        pop     bx
        ret
;
xorpt   endp