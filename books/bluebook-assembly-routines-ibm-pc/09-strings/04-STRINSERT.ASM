; Insert One String in Another

; Function:
; This routine inserts a source string in a specified place in a
; destination string. See Figure 9-1.

; Input:
; Upon entry DS:BX points to the source string, ES:BP points to
; the destination string, and ES:DX points to the spot in the destination
; where the source is to be placed. Each string begins with a 16-bit integer
; which specifies its length.

; Output:
; Upon exit the destination string has the source string inserted
; in the proper place. The length of the destination is increased
; accordingly.

; Registers Used:
; No registers are modified.

; Segments Referenced:
; Upon entry the data segment must contain the
; source string and the extra segment must contain the destination string.

; Routines Called: 
; None

; Special Notes:
; None



; ROUTINE TO INSERT ONE STRING WITHIN ANOTHER
;
; addressing equates
essorc  equ     es:[si]         ; equate for source in extra seg
dsdest  equ     byte ptr[di]    ; equate for usual destination
;
strinsert       proc    far
;
        push    si              ; save registers
        push    di
        push    cx
        push    ax
;
; find current end of destination string
        mov     si,bp           ; start of string
        add     si,es:[si]      ; point to next to last byte
        inc     si              ; adjust for length information
;
; find new end of destination string and update length
        mov     di,si           ; get old end of destination
        mov     ax,[bx]         ; get length of source
        add     di,ax           ; new end of destination
        add     es:[bp],ax      ; new length of destination
;
; move tail of destination string out of the way
        mov     cx,si           ; SI - DX + 1 is the count
        sub     cx,dx
        inc     cx
        std                     ; backward direction
rep     movs    dsdest,essorc   ; move the tail
;
; move source string into place
        mov     di,dx           ; destination of move
        mov     si,bx           ; source of move
        cld                     ; forward direction
        lodsw                   ; length of source
        mov     cx,ax           ; the count
        rep     movsb           ; make the string move
;
strinsertexit:
        pop     ax              ; restore registers
        pop     cx
        pop     di
        pop     si
        ret
;
strinsert       endp