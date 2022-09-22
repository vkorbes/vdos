; Linear Scaling

; Function:
; This routine performs a linear scaling, converting a fixed
; point number between 0 and 1 to an integer between X1 and X2, where
; X1 and X2 are 16-bit integers.

; Input: 
; Upon entry CX has a binary fixed point number between 0 and
; 1. The binary point is to the left of the leftmost bit. X1 and X2 are
; variables stored in memory.

; Output: 
; Upon exit CX contains the 16-bit integer result.

; Registers Used: 
; Only CX is modified.

; Segments Referenced:
; The data segment must contain the variables X1
; and X2.

; Routines Called:
; None

; Special Notes:
; None



; ROUTINE TO SCALE LINEARLY
;
scale   proc    far
;
        push    dx              ; save registers
        push    ax
;
; compute width
        mov     ax,x2           ; get x2
        sub     ax,x1           ; subtract x1
;
; multiply width by input parameter
        mul     cx              ; multiply
        mov     cx,dx           ; move top part of quotient into CX
;
; add lower limit
        add     cx,x1           ; add x1
;
        pop     ax              ; restore registers
        pop     dx
        ret
;
scale   endp