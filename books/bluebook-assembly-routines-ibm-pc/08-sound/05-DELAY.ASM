; Delay for Specified Number of Milliseconds

; Function:
; Delays a specified number of milliseconds.

; Input:
; Upon input CX contains the number of milliseconds to delay.

; Output: 
; None

; Registers Used:
; No registers are modified.

; Segments Referenced:
; None

; Routines Called:
; None

; Special Notes:
; None



; ROUTINE TO DELAY SPECIFIED NUMBER OF MILLISECONDS
delay   proc    far
;
        push    cx              ; save registers
;
delay1:
        push    cx              ; save counter
        mov     cx,260          ; timing constant
delay2:
        loop    delay2          ; small loop
        pop     cx              ; restore counter
        loop    delay1          ; loop to count milliseconds
;
        pop     cx              ; restore registers
        ret
;
delay   endp