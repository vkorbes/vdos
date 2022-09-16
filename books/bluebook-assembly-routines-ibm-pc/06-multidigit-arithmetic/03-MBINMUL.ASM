; Multidigit Binary Multiplication

; Function:
; This routine multiplies two multidigit binary numbers.

; Input:
; Upon entry DS:SI points to the first number, DS:DI points to the
; second number, and DS:BX points to the location where the result will be
; stored. The size of these multidigit numbers is controlled by the constant
; ISIZE. The input numbers contain 16*SIZE number of bits and the
; Output number has double that precision. Both inputs are stored in
; ISIZE number of 16-bit words of memory and the output is stored in
; 2*SIZE number of 16-bit words of memory.

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



; ROUTINE TO MULTIPLY MULTDIGIT BINARY NUMBERS
;
mbinmul proc    far
;
        push    si              ; save registers
        push    di
        push    bx
        push    cx
        push    ax
;
; clear result buffer
        push    bx              ; save result pointer in BX
        mov     ax,0            ; get a zero
        mov     cx,2*isize      ; double precision for this number
        cld                     ; forward direction
mbinmul1:
        mov     [bx],ax         ; clear the "digit"
        inc     bx              ; point to next "digit"
        inc     bx
        loop    mbinmul1        ; loop through all "digits"
        pop     bx              ; restore result pointer BX
;
        mov     cx,isize        ; get the number of 16-bit "digits"
mbinmul2:
        push    cx              ; save count for outer loop
        mov     dx,[si]         ; get "digit" from first number
        inc     si              ; point to next "digit"
        inc     si
;
        push    bx              ; save registers during inner loop
        push    di
;
        mov     cx,isize        ; get the number of 16-bit "digits"
mbinmul3:
        push    cx              ; save count for inner loop
        push    dx              ; save multiplier "digit"
        mov     ax,[di]         ; get "digit" from second number
        inc     di              ; point to next "digit"
        inc     di
        mul     dx              ; multiply
        add     [bx],ax         ; add lower "digit" to result
        inc     bx              ; point to next "digit"
        inc     bx          
        adc     [bx],dx         ; add upper part to result
        pop     dx              ; restore multiplier
        pop     cx              ; restore count for inner loop
        loop    mbinmul3        ; loop through all "digits" of second
;
        pop     di              ; restore registers
        pop     bx
;
        inc     bx              ; shift by one "digit"
        inc     bx
        pop     cx              ; restore count for outer loop
        loop    mbinmul2        ; loop through all "digits" of first
;
        pop     ax              ; restore registers
        pop     cx
        pop     bx
        pop     di
        pop     si
        ret
;
mbinmul endp