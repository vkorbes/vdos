; Multidigit Binary Division

; Function: 
; This routine divides two multidigit binary numbers,
; producing both a quotient and remainder.

; Input:
; Upon entry, DS:SI points to the divisor, DS:BX points to where
; the dividend is upon entry and where the remainder will be upon exit,
; and D:DI points to the location where the quotient will be upon exit.
; The size of these multidigit numbers is controlled by the constant ISIZE.
; The divisor and quotient contain 16*SIZE number of bits and the
; dividend and remainder have double that precision. Both the divisor and
; quotient are stored in ISIZE number of 16-bit words of memory and the
; dividend and remainder are stored in 2*ISIZE number of 16-bit words of
; memory.

; Output:
; Upon exit DS:BX points to where the quotient is stored and
; DS: DI points to where the remainder is stored.

; Registers Used: 
; No registers are modified.

; Segments Referenced:
; Upon entry the data segment must contain
; storage for the multidigit numbers described above.

; Routines Called: 
; None

; Special Notes: 
; None



; LOCAL SUBROUTINE TO COMPARE DIVISOR AGAINST DIVIDEND
;
divcmp  proc    near
;
        push    si              ; save registers
        push    di
        push    cx
;
        std                     ; backward direction
        add     si,4*isize-2    ; point to end of temp divisor
        add     di,4*isize-2    ; point to end of quotient
        mov     cx,2*isize      ; count for double precision
;
        repz    cmpsw           ; compare "digit" by "digit"
;
        pop     cx              ; restore registers
        pop     di
        pop     si
        ret
;
divcmp  endp
;
;
; LOCAL SUBROUTINE TO ARITHMETIC SHIFT DIVISOR LEFT
;
divsal  proc    near
;
        push    si              ; save registers
        push    cx
;
        mov     cx,2*isize      ; set counter
        clc                     ; clear carry in
divsal1:
        rcl     word ptr [si],1 ; shift one word by one bit
        inc     si              ; point to next word
        inc     si
        loop    divsal1         ; loop through entire divisor
;
        pop     cx              ; restore registers
        pop     si
        ret
;
divsal  endp
;
;
; LOCAL SUBROUTINE TO LOGICAL SHIFT DIVISOR RIGHT
;
divslr  proc    near
;
        push    si              ; save registers
        push    cx
;
        add     si,4*isize-2    ; point to end of temp divisor
        mov     cx,2*isize      ; count for double precision
        clc                     ; clear carry in
divslr1:
        rcr     word ptr [si],1 ; rotate one word by one bit
        dec     si              ; point to next word
        dec     si
        loop    divslr1         ; loop through entire divisor
;
        pop     cx              ; restore registers
        pop     si
        ret
;
divslr  endp
;
;
; LOCAL SUBROUTINE TO SUBTRACT SHIFTED DIVISOR FROM DIVIDEND
;
divsub  proc    near
;
        push    si              ; save registers
        push    di
        push    cx
;
        clc                     ; clear carry in
        mov     cx,2*isize      ; set the count for double precision
divsub1:
        mov     ax,[si]         ; get word from shifted divisor
        inc     si              ; point to next word
        inc     si
        sbb     [di],ax         ; subtract from word of dividend
        inc     di              ; point to next word
        inc     di
        loop    divsub1         ; loop through all words
;
        pop     cx              ; restore registers
        pop     di
        pop     si
        ret
;
divsub  endp
;
; LOCAL SUBROUTINE TO SHIFT QUOTIENT LEFT
;
quotshl proc    near
;
        push    bx              ; save registers
        push    cx
;
        mov     cx,isize        ; count for single precision
quotshl1:
        rcl     word ptr [bx],1 ; shift word of quotient left once
        inc     bx              ; point to next word
        inc     bx
        loop    quotshl1        ; loop through entire quotient
;
        pop     cx              ; restore registers
        pop     bx
        ret
;
quotshl endp
;
;
; ROUTINE TO DIVIDE MULTIDIGIT BINARY NUMBERS
;
mbindiv proc    far
;
        push    si              ; save registers
        push    di
        push    bx
        push    cx
        push    ax
;
; put single precision divisor into double precision location
        push    di              ; save dividend pointer
        lea     di,tempdiv      ; point to temporary divisor
        mov     cx,isize        ; for a count of isize
        cld                     ; forward direction
        rep     movsw           ; make the transfer
;
; clear upper part of double precision location
        mov     ax,0            ; zero word
        mov     cx,isize        ; for a count of isize
        rep     stosw           ; clear the rest of the words
;
; restore dividend pointer and point to temp divisor
        pop     di              ; restore dividend pointer
        lea     si,tempdiv      ; point to SI to temporary divisor
;
; initialize shift count
        mov     cx,1            ; initial count of one
;
; normalize divisor
mbindiv1:
        test    msbdiv,8000h    ; test msb of divisor
        jnz     mbindiv2        ; exit if normalized
        call    divsal          ; arithmetic shift left if not
        inc     cx              ; count the shift
        jmp     mbindiv1        ; keep on looping until normalized
;
; compare, subtract, shift loop
mbindiv2:
        call    divcmp          ; compare divisor against dividend
        ja      mbindiv3        ; skip if too large
        call    divsub          ; subtract if ok
        stc                     ; new bit of quotient is 1
        jmp     mbindiv4        ; jump to end of loop
;
mbindiv3:
        clc                     ; new bit of quotient is 0
mbindiv4:
        call    quotshl         ; shift bit into the quotient
        call    divslr          ; logical shift divisor right once
        loop    mbindiv2        ; loop for next digit
;
        pop     ax              ; restore registers
        pop     cx
        pop     bx
        pop     di
        pop     si
        ret
;
mbindiv endp