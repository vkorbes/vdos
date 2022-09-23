; Switch Two Strings

; Function:
; This routine switches two strings.

; Input:
; Upon entry DS:SI points to one string (the source) and ES:DI
; points to a second string (the destination). Both strings have lengths
; given by CX.

; Output:
; Upon exit the strings are switched.

; Registers Used:
; No registers are modified.

; Segments Referenced:
; Upon entry the data segment contains the source
; string and the extra segment contains the destination string.

; Routines Called: 
; None

; Special Notes:
; None



; ROUTINE TO SWITCH TWO STRINGS
;
switch  proc    far
;
        push    si              ; save registers
        push    di
        push    cx
        push    ax
;
        cld                     ; forward direction
switch1:
        mov     al,[di]         ; get byte from destination
        movsb                   ; move from source to destination
        mov     es:[si-1],al    ; put byte in source
        loop    switch1         ; loop back for more
;
        pop     ax              ; restore registers
        pop     cx
        pop     di
        pop     si
        ret
;
switch  endp