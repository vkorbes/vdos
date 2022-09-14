; Conversion from BCD to ASCII Decimal

; Function:
; This routine converts a 36-digit number stored in BCD form
; to ASCII decimal form which is sent to the standard output device.

; Input: 
; Upon entry a 36-digit number is stored in an 18-byte BCD
; buffer called BCDBUFF.

; Output: 
; A string of ASCII digits representing a decimal number is
; stored in a buffer called BUFF and then sent out through a standard
; I/O routine.

; Registers used: 
; No registers are modified.

; Segments referenced: 
; DATAS is a data segment containing BCDBUFF and TBUFF.

; Routines called: 
; STDOUT

; Special notes:
; None



; ROUTINE TO CONVERT FROM INTERNAL BCD TO ASCII DECIMAL
;
bcdout  proc    far
;
        push    ds              ; save registers
        push    si
        push    dx
        push    cx
        push    ax
;
; set up data segment
        mov     ax,datas        ; point to data segment
        mov     ds,ax
;
        mov     cx,18           ; for a count of 18
        lea     si,bcdbuff      ; point to bcd buffer
        add     si,17           ; point to end of bcd buffer
        mov     dh,0            ; clear flag for leading zeros
;
bcdout1:
        push    cx              ; save loop count
        mov     al,[si]         ; get BCD byte
        dec     si              ; and point to next
        mov     dl,al           ; save it
;
; upper digit
        mov     cl,4            ; for a count of 4
        rol     al,cl           ;  rotate byte
        and     al,0Fh          ; just the digit
        or      dh,al           ; leading zeros?
        jz      bcdout2         ; if so skip digit
        add     al,30h          ; make ASCII
        call    stdout          ; send it out
bcdout2:
;
        pop     cx              ; restore count
        cmp     cx,1            ; last digit?
        jnz     bcdout3         ; skip if not
        mov     dh,0FFh         ;  set flag if so
bcdout3:
        push    cx              ; save count
;
        mov     al,dl           ; byte back
;
; lower digit
        and     al,0Fh          ; just the digit
        or      dh,al           ; leading zeros?
        jz      bcdout4         ; if so skip digit
        add     al,30h          ; make ASCII
        call    stdout          ; send it out
bcdout4:
;
        pop     cx              ; restore loop count
        loop    bcdout1      
;
        pop     ax              ; restore registers
        pop     cx
        pop     dx
        pop     si
        pop     ds
        ret                     ; return
;
bcdout  endp