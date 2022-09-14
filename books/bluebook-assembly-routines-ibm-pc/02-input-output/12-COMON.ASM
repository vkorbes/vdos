; Communications Line On

; Function:
; This routine turns on the handshaking signals DTR (line 20)
; and RTS (line 4) on the specified communications line.

; Input:
; Upon entry DX contains the unit number (O for com1: and 1 for
; com2:).

; Output: 
; Just to the communications line.

; Registers Used:
; No registers are modified. DX is used for input.

; Segments Referenced:
; During the routine the system data segment is
; referenced.

; Routines Called:
; None

; Special Notes:
; None



; ROUTINE TO TURN ON INPUT FROM A COMMUNICATIONS LINE
;
comon   proc    far
;
        push    ds                  ; save registers
        push    dx
        push    si
;
        mov     si,dx               ; look up address of com line
        add     si,si               ; double to index into table
        mov     dx,40h              ; segment of system I/O table
        mov     ds,dx               ; set data segment to this table
        mov     dx,[si]             ; now get it
        add     dx,4                ; modem control register
        mov     al,3                ; set DTR and RTS
        out     dx,al               ; send out control byte
;
        pop     si                  ; restore registers
        pop     dx
        pop     ds
        ret
;
comon   endp