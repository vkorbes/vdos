; Communications Line Input Check

; Function:
; This routine checks, but does not wait for input from one of
; the two serial communications lines.

; Input:
; Upon entry DX contains the unit number (0 for com1: and 1 for
; com2:). During the routine, input is from the specified communications
; line.

; Output:
; If a byte is available, the routine returns with the flag condition
; NZ and the byte in AL., but if no byte is available then the routine returns
; with the flag condition Z., and AL. is meaningless.

; Registers Used:
; AH is modified. DX is used for input and AL is used
; for output.

; Segments Referenced: During the routine the system data segment is
; referenced.

; Routines Called:
; None

; Special Notes:
; None



; ROUTINE TO CHECK FOR INPUT FROM A COMMUNICATIONS LINE
;
cominck proc    far
;
        push    ds              ; save registers
        push    dx
        push    si
;
        mov     si,dx           ; look up address of com line
        add     si,si           ; double to index into table
        mov     dx,40h          ; segment of table
        mov     ds,dx           ; set data segment to this table
        mov     dx,[si]         ; now get it
        add     dx,5            ; line status
        in      al,dx           ; get it
        test    al,1            ; receive buffer full?
        jz      cominckexit
;
        mov     dx,[si]         ; data register
        in      al,dx           ; get it
cominckexit:
;
        pop     si              ; restore registers
        pop     dx
        pop     ds
        ret
;
cominck endp