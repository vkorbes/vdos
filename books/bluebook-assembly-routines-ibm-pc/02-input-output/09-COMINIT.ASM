; Initialize Communications Line

; Function:
; This routine initializes one of the two communications lines.

; Input:
; Upon entry AL. contains the initialization byte as follows:

;      7    6    5    4      3         2           1     0
;     --baud rate--  --parity--  --stop bit--  --word length--
;     000 =   110    00 = none   0 = 1         10 = 7 bits
;     001 =   150    01 = odd    1 = 2         11 = 8 bits
;     010 =   300    10 = none
;     011 =   600    11 = even
;     100 =  1200
;     101 =  2400
;     110 =  4800
;     111 =  9600

; DX contains the unit number (0 for com: and 1 for com2:).

; Output:
; Output is sent to the hardware controlling the specified
; communications line.

; Registers Used:
; No registers are modified.

; Segments Referenced:
; None

; Routines Called: 
; BIOS interrupt 14h (RS-232 I/O) is used.

; Special Notes:
; None



; ROUTINE TO INITIALIZE A COMMUNICATIONS LINE
;
cominit proc    far
;
        mov     ah,0            ; initialize
        int     14h             ; RS232 BIOS call
        ret                     ; return
;
cominit endp