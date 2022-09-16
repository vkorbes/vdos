; Locate a Point on the Medium Resolution Color Screen

; Function: 
; This routine returns the color of a point on the medium
; resolution screen. The color is returned in AL

; Input:
;     Upon entry:
;     ×-coordinate (0-319) of the point is in SI
;     y-coordinate (0-199) of the point is in DI

; Output:
; Upon exit AL contains the color (0-3) of the pixel at the
; specified location.

; Registers Used:
; Only AX is modified. SI and DI are used for input and
; AL is used for output.

; Segments Referenced:
; Upon entry ES must point to the video RAM at B8000h.

; Routines Called:
; None

; Special Notes:
; No bounds checking is performed. The user must make
; sure that the coordinates are in their proper ranges.



; ROUTINE TO RETURN COLOR OF A POINT ON MEDIUM RES COLOR SCREEN
;
locate  proc    far
;
        push    bx              ; save registers
        push    cx
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
        add     bx,ax           ; address gets times 64 + times 16
;
; add x-coord to address
        mov     ax,si           ; get x-coordinate
        sar     ax,1            ; divide
        sar     ax,1            ; by 4
        add     bx,ax           ; here is the address
;
; compute the position of the pixel in the byte
        mov     cx,si           ; use x-coordinate to determine count
        and     cx,3            ; just the bit count
        inc     cx              ; plus one
        sal     cx,1            ; 2 bits per pixel
;
; get the byte and rotate into place
        mov     al,es:[bx]      ; get old byte
        rol     al,cl           ; rotate left this many times
        and     ax,3            ; just the pixel color
;
        pop     cx              ; restore the registers
        pop     bx
        ret
;
locate endp