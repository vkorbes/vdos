; Multidigit Binary Subtraction

; Function:
; This routine subtracts two multidigit binary numbers.

; Input: 
; Upon entry DS:SI points to the first number, DS:DI points to the
; second number, and DS:BX points to the location where the result of
; subtracting the first from the second will be stored. The size of these
; multidigit numbers is controlled by the constant ISIZE. All three
; numbers contain 16*ISIZE number of bits and are stored in ISIZE
; number of 16-bit words of memory.

; Output: 
; Upon exit DS:BX points to where the result is stored.

; Registers Used: 
; No registers are modified.

; Segments Referenced:
; Upon entry the data segment must contain storage
; for three multidigit numbers, two for input and one for output.

; Routines Called: 
; None

; Special Notes:
; None



; ROUTINE TO SUBTRACT MULTIDIGIT BINARY NUMBERS
;
mbinsub proc    far
;
        push    si              ; save registers
        push    di
        push    bx
        push    cx
        push    ax
;
        mov     cx,isize        ; get the number of 16-bit "digits"
        clc                     ; clear the carry
mbinsub1:
        mov     ax,[di]         ; get "digit" from second number
        inc     di              ; point to next "digit"
        inc     di
        sbb     ax,[si]         ; subtract "digit" of first number
        inc     si              ; point to next "digit"
        inc     si
        mov     [bx],ax         ; move resulting "digit" into place
        inc     bx              ; point to next "digit"
        inc     bx              
        loop    mbinsub1        ; loop through all "digits"
;
        pop     ax              ; restore registers
        pop     cx
        pop     bx
        pop     di
        pop     si
        ret
;
mbinsub endp