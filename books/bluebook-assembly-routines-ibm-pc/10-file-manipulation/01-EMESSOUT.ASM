; Exception Message Output

; Function: 
; This routine sends a specified exception message out through
; the standard output device.

; Input:
; Upon entry AX contains the exception message number as listed
; in the table below. This table is an extension of the Error Return Table in
; the DOS 2 Disk Operating System manual.

; Output:
; The output is sent to the standard output device.

; Registers Used:
; AX is used for input.

; Segments Referenced:
; Upon entry the data segment must contain the
; text of the exception messages as in the following table:



emess   dw      emess1
        dw      emess2
        dw      emess3
        dw      emess4
        dw      emess5
        dw      emess6
        dw      emess7
        dw      emess8
        dw      emess9
        dw      emess10
        dw      emess11
        dw      emess12
        dw      emess13
        dw      emess14
        dw      emess15
        dw      emess16
        dw      emess17
        dw      emess18
;
emess1  db      cr,lf,'Invalid function number',cr,lf,0
emess2  db      cr,lf,'File not found',cr,lf,0
emess3  db      cr,lf,'Path not found',cr,lf,0
emess4  db      cr,lf,'Too many open files',cr,lf,0
emess5  db      cr,lf,'Access denied',cr,lf,0
emess6  db      cr,lf,'Invalid handle',cr,lf,0
emess7  db      cr,lf,'Memory control blocks destroyed',cr,lf,0
emess8  db      cr,lf,'Insufficient memory',cr,lf,0
emess9  db      cr,lf,'Invalid memory block address',cr,lf,0
emess10 db      cr,lf,'Invalid environment',cr,lf,0
emess11 db      cr,lf,'Invalid format',cr,lf,0
emess12 db      cr,lf,'Invalid access code',cr,lf,0
emess13 db      cr,lf,'Invalid data',cr,lf,0
emess14 db      cr,lf,'Message not in use',cr,lf,0
emess15 db      cr,lf,'Invalid drive was specified',cr,lf,0
emess16 db      cr,lf,'Attempted to remove the current directory',cr,lf,0
emess17 db      cr,lf,'Not same device',cr,lf,0
emess18 db      cr,lf,'No more files',cr,lf,0



; The first part of the table consists of addresses of the messages and
; the second part consists of the actual messages as ASCIIZ strings.

; Routines Called:
; MESSOUT

; Special Notes:
; None.



; ROUTINE TO SEND OUT EXCEPTION MESSAGES
;
emessout        proc    far
;
        push    si              ; save registers
        push    ax
;
        add     ax,ax           ; double to index through table
        mov     si,ax           ; SI points into table
        mov     si,emess[si]    ; look up address of message
        call    messout         ; send the message
;
        pop     ax              ; restore registers
        pop     si
        ret
;
emessout        endp