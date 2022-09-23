; Filter to Help Convert Files to WordStar Format

; Function:
; This routine filters a file, replacing any single cr/lf by a "soft"
; cr/If and any double cr/If by a "soft" then a "hard" cr/lf. Tabs are not
; expanded.

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
; STDINNE, STDOUTDR

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
; ROUTINE TO HELP CONVERT FILES TO WORDSTAR FILES
;
wsfilter        proc    far
;
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
wsfilter1:
;
; get the next character
        call    stdinne         ; get the character without echo
;
; work on carriage returns
wsfilter2:
        cmp     al,0Dh          ; hard carriage return
        jne     wsfilter3       ; skip if not
        cmp     lastbyte,10     ; last character = linefeed?
        je      wsfilter3       ; skip if so
        mov     al,8Dh          ; soft carriage return
;
; send the character out
wsfilter3:
        call    stdoutdr        ; send it out
        mov     lastbyte,al     ; update last byte
;
; check for end of file
        cmp     al,controlz     ; end of file?
        jne     wsfilter1       ; if not, back for more
;
; exit
wsfilterexit:
        ret
;
wsfilter        endp
codes   ends                    ; end of code segment
        end     wsfilter