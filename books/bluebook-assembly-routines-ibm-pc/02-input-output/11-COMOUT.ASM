; Communications Line Output

; Function:
; This routine sends a byte out one of the two communications
; lines.

; Input:
; Upon entry AL contains the byte to be sent out and DX contains
; the unit number (0 for com1: and 1 for com2:).

; Output:
; Output is sent to the specified communications line.

; Registers Used:
; No registers are modified.

; Segments Referenced:
; None

; Routines Called:
; BIOS interrupt 14h (RS-232 I/O) is used.

; Special Notes:
; None



; ROUTINE TO SEND OUTPUT TO A COMMUNICATIONS LINE
;
comout  proc    far
;
        mov     ah,1            ; send it out
        int     14h             ; RS232 BIOS call
        ret                     ; return
comout  endp