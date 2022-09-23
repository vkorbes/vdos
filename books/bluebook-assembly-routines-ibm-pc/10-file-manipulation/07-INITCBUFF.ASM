; Initialize Circular Buffer

; Function:
; This routine initializes the pointers and control variables for
; a circular buffer.

; Input:
; None.

; Output:
; The registers SI and DI and the variable GAUGE are all set to
; zero. The variable LASTBYTE is also set equal to zero.

; Registers Used:
; DI and SI are set to zero. All other registers are left alone.

; Segments Referenced:
; Upon entry the data segment must contain the
; circular buffer and its variables, BUFF and GAUGE, and the variable
; LASTBYTE.

; Routines Called:
; None.

; Special Notes:
; None.



; ROUTINE TO HANDLE INPUT FOR CIRCULAR BUFFER
;
initcbuff       proc    far
;
        mov     si,0            ; initialize SI
        mov     di,0            ; initialize DI
        mov     gauge,0         ; and number of bytes in buffer
        mov     lastbyte,0      ; also last byte buffer
;
        ret
;
initcbuff       endp