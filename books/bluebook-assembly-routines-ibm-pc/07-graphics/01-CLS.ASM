; Clear the Graphics Screen

; Function:
; This routine clears the color graphics screen.

; Input:
; None

; Output: 
; Just to the screen.

; Registers Used: 
; No registers are modified.

; Segments Referenced: 
; Upon entry ES must point to the screen RAM at B8000h.

; Routines Called: 
; None

; Special Notes:
; None



; ROUTINE TO CLEAR THE GRAPHICS SCREEN
;
cls     proc    far
;
        push    cx              ; save registers
        push    ax
;
; set up the registers
        mov     cx,2000h        ; word count of whole screen
        mov     ax,0            ; zero pattern for the screen
        mov     di,ax           ; set starting address
        cld                     ; go in forward direction
;
; clear the screen with a single string operation
        rep     stosw           ; this clears the screen
;
        pop     ax              ; restore registers
        pop     cx
        ret
cls     endp