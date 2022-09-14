; Conversion from BCD to 16-Bit Binary

; Function:
; This routine converts from internal BCD format to internal
; binary format.

; Input:
; Upon entry a 36-digit number is contained in an 18-digit BCD
; buffer called BCDBUFF.

; Output: 
; A 16-bit binary number is returned in the DX register.

; Registers used: 
; Only DX is modified. DX is used for output.

; Segments referenced: 
; DATAS is a data segment which contains the buffer BCDBUFE.

; Routines called: 
; None

; Special notes: 
; None



; ROUTINE TO CONVERT FROM INTERNAL BCD TO INTERNAL 16-BIT BINARY
;
bcd2i16 proc    far
;
        push    ds              ; save registers
        push    si 
        push    cx
        push    ax
;
; set up data segment
        mov     ax,datas        ; point to data segment
        mov     ds,ax           
;
; set up loop
        mov     cx,18           ; initialize counter
        lea     si,bcdbuff      ; point to buffer
        add     si,17           ; point to end of bcd buffer
        mov     dx,0            ; set DX to zero
;
bcd2i161:
        push    cx              ; save loop count
        mov     al,[si]         ; get BCD byte
        dec     si              ; and point to next
        mov     bl,al           ; save it
;
; upper digit
        mov     cl,4            ; for a count of 4
        rol     al,cl           ;  rotate byte
        and     al,0Fh          ; just the digit
        cbw
;
        push    ax              ; save digit
        mov     ax,dx
        mov     cx,10           ; multiplier of 10
        mul     cx              ; multiply
        mov     dx,ax           ; result in DX
        pop     ax              ; restore digit
;
        add     dx,ax           ; add in digit
;
        mov     al,bl           ; byte back
;
; lower digit
        and     al,0Fh          ; just the digit
        cbw
;
        push    ax              ; save digit
        mov     ax,dx           
        mov     cx,10           ; multiplier of 10
        mul     cx              ; multiply
        mov     dx,ax           ; result in DX
        pop     ax              ; restore digit
;
        add     dx,ax           ; add in digit
; 
        pop     cx              ; restore loop count
        loop    bcd2i161
;
        pop     ax              ; restore registers
        pop     cx
        pop     si
        pop     ds
        ret                     ; return
;
bcd2i16 endp