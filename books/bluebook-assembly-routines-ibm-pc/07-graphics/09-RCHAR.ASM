; Plot a Raster Character

; Function:
; This routine plots a raster character. It uses the raster
; character table in the IBM BIOS ROM. Only ASCII codes 0 through 127
; are supported.

; Input:
;     Upon entry:
;     ASCII code character is in AL
;     ×-coordinate of upper left corner of character cell is in ×0
;     -coordinate of upper left corner of character cell is in yO
;     horizontal magnitude is in xmagn
;     vertical magnitude is in ymagn
;     color of the character is in color

; Output: 
; Just to the screen.

; Registers Used:
; No registers are modified.

; Segments Referenced:
; Upon entry ES must point to the video RAM at
; B8000h and DS must point to the data segment used by the box-fill
; routine.

; Routines Called:
; SETBOX

; Special Notes:
; No bounds checking is performed. Unpredictable results
; happen if the horizontal or vertical magnitude is too large. A string of
; raster characters can be printed using the GMESSOUT routine below.



; ROUTINE TO PLOT A RASTER CHARACTER
;
rchar   proc    far
;
        push    si              ; save registers
        push    dx
        push    cx
        push    ax
;
; look up pattern for character
        cbw                     ; convert from byte to word
        sal     ax,1            ; times 2
        sal     ax,1            ; times 4
        sal     ax,1            ; times 8
        add     ax,0FA6Eh+7     ; character table + pattern end
        mov     si,ax           ; here is the offset
;
        mov     dx,ds           ; save old DS
        mov     ax,0F000h       ; point DS to ROM segment
        mov     ds,ax           ; here is the data segment
;
; store the pattern on the stack
        mov     cx,8            ; for a count of eight bytes
        std                     ; backward direction
rchar1:
        lodsb                   ; load
        push    ax              ; push onto stack
        loop    rchar1
;
        mov     ds,dx           ; restore data segment
;
; get the starting point
        mov     ax,x0           ; get x-coordinate
        mov     x1,ax
        mov     ax,y0           ; get y-coordinate
        mov     y1,ax
;
        mov     cx,8            ; for a count of 8 rows
rchar2:
        pop     dx              ; get the next row
        push    cx              ; save the count
;
        mov     al,ymagn        ; vertical sizing
        cbw
        dec     ax              ; one less
        add     ax,y1           ; add to new dot position
        mov     y2,ax
;
        mov     cx,8            ; for a count of 8 dots
rchar3:
        push    cx              ; save the count
;
        mov     al,xmagn        ; horizontal sizing
        cbw
        dec     ax              ; one less
        add     ax,x1           ; add to new dot position
        mov     x2,ax
;
        test    dl,80h          ; check the dot
        jz      rchar4          ; skip it if zero
;
        call    setbox          ; plot it if one
rchar4:
        mov     ax,x2           ; next column
        inc     ax              ; one over from end of box
        mov     x1,ax           ; into next dot position
        rol     dl,1            ; next dot from pattern
        pop     cx              ; restore count of dots
        loop    rchar3          ; loop for next dot
;
        mov     ax,x0           ; restore to first column
        mov     x1,ax           ; beginning of row
        mov     ax,y2           ; next row
        inc     ax              ; one down from end of box
        mov     y1,ax           ; into next row position
        pop     cx              ; restore count of rows
        loop    rchar2          ; loop for next row
;
        pop     ax              ; restore registers
        pop     cx
        pop     dx
        pop     si
        ret
;
rchar   endp