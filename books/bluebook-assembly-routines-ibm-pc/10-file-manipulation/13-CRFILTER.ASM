; Filter For Carriage Return/Linefeed

; Function:
; This routine filters a file, replacing carriage returns by
; carriage return/linefeeds. Tabs are expanded.

; Input:
; Input is from the standard input device.

; Output:
; The output is sent to the standard output device.

; Registers Used: 
; Registers are used as needed. This is the main program
; of an EXE command file.

; Segments Referenced:
; Upon entry the segments must be as specified for
; entry to EXE files.

; Routines Called: 
; STDINNE, STDOUT

; Special Notes:
; None



;
controlz        equ     1Ah     ; control Z
;
        extrn   stdinne:far,stdout:far
;
;**********************************************************
datas   segment public
;
lastbyte        db      0
;
datas   ends
;**********************************************************
stacks  segment stack
        db      20 dup('stack   ')
stacks  ends
;**********************************************************
codes   segment
;
        assume  cs:codes,ds:datas
;
; ROUTINE TO FILTER FILES FOR CARRIAGE RETURNS
;
crfilter        proc    far
;
; set up return
        push    ds              ; save for proper return
        mov     ax,0            ; points to beginning of segment
        push    ax              ; for the offset
;
; set up segments
        mov     ax,datas        ; new data segment
        mov     ds,ax           ; put in DS
        mov     es,ax           ; and in ES
;
; main loop
crfilter1:
;
; get the next character
        call    stdinne         ; get the character without echo
;
; strip off bit 7
        and     al,7Fh          ; just 7 bits
;
; check for linefeed
        cmp     al,10           ; ASCII 10
        jne     crfilter2       ; skip if not linefeed
        cmp     lastbyte,13     ; was last byte a carriage return?
        je      crfilter3       ; skip if cr/lf
;
crfilter2:
        call    stdout          ; send it out
        mov     lastbyte,al     ; update last byte
;
; check for carriage return
crfilter3:
        cmp     al,13           ; ASCII 13
        jne     crfilter4       ; skip if so
;
        push    ax              ; save current character
        mov     al,10           ; put a linefeed
        call    stdout          ; out the standard output
        pop     ax              ; restore current character
;
; check for end of file
crfilter4:
        cmp     al,controlz     ; end of file?
        jne     crfilter1       ; if not, back for more
;
; exit
crfilterexit:
        ret
;
crfilter        endp
codes   ends                    ; end of code segment
        end     crfilter