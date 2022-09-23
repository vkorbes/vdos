; Compare Two Strings

; Function:
; This routine compares two strings of the same length.

; Input:
; Upon entry DS:SI points to one string (the source) and DS:DI
; points to a second string (the destination). Both strings have lengths
; given by CX.

; Output:
; Upon exit the flags specify the relation of the source to the
; destination:
;     l = source string is less than the destination string
;     e = source string is equal to the destination string
;     g = source string is greater than the destination string

; Registers Used: 
; Only AX is modified.

; Segments Referenced:
; Upon entry the data segment contains the source
; string and the extra segment contains the destination string.

; Routines Called:
; None

; Special Notes:
; None



; ROUTINE TO COMPARE TWO STRINGS
;
compare proc    far
;
        push    si              ; save registers
        push    di
        push    cx
;
        repz    cmpsb           ; one compare does it!
;
        pop     cx              ; restore registers
        pop     di
        pop     si
        ret
;
compare endp