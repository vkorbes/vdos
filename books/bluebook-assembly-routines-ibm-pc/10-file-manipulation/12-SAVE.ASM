; Save a File from Communications Line to Disk

; Function:
; This routine saves a file from a communications line to a disk
; file.

; Input:
; Upon entry the file specifier is in the unformatted parameter
; area of the program segment prefix. This contains the tail of the
; command line which invoked the SAVE command. During the routine
; input is from the communications line which in this case is com?:
; initialized as 2400 baud, even parity, 8-bit data word, and one stop bit.

; Output:
; The output is sent to the disk file.

; Registers Used:
; Registers are used as needed. This is the main program
; of an EXE command file.

; Segments Referenced:
; Upon entry the segments must be as for entry to EXE files.

; Routines Called:
; GETSPEC, CREATEFILE, CLOSEFILE,
; INITCBUFE, INCBUFF, OUTCBUFF, COMINIT, COMON,
; EMESSOUT

; Special Notes:
; None



;
        extrn   stdinck:far
        extrn   emessout:far,getspec:far
        extrn   createfile:far,closefile:far
        extrn   cominit:far,comon:far,comoff:far
        extrn   initcbuff:far,incbuff:far,outcbuff:far
        extrn   flushit:far
        extrn   dta:dword
;
;**********************************************************
datas   segment public
;
namebuff        db      256 dup(0)
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
; ROUTINE TO SAVE FILE FROM COMMUNICATION LINE TO DISK
;
save    proc    far
;
; set up return
        push    ds              ; save for proper return
        mov     ax,0            ; points to beginning of segment
        push    ax              ; for the offset
;
; set up segments
        mov     dx,ds           ; program segment prefix was data seg
        mov     ax,datas        ; new data segment
        mov     ds,ax           ; put in DS
        mov     es,ax           ; and in ES
        mov     dta+2,dx        ; set the segment of the data
;
; set up the file
        lea     dx,namebuff     ; point to ASCIIZ buffer
        call    getspec         ; get file specifications
        jc      exception       ; error?
        lea     dx,namebuff     ; ASCIIZ buffer has file specifiers
        call    createfile      ; set up the file
        jc      exception       ; error?
        mov     bx,ax           ; get the file handle
;
; set up the communications line
        mov     dx,1            ; for com2:
        mov     al,0BBh         ; 2400:e,8,1
        call    cominit         ; initialize it
        call    comon           ; turn it on
;
; initialize the buffer
        call    initcbuff       ; initialize the buffer
        mov     dx,1            ; com2:
;
; main loop for pulling in bytes
saveloop:
        call    incbuff         ; check for input
        jc      exception       ; error or end of file?
        call    outcbuff        ; check to send it out
        jc      exception       ; error?
        jmp     saveloop
;
; handle exceptions
exception:
        cmp     ax,19           ; end of file?
        je      save1           ; if so close it up and return
;
        call    emessout        ; report the error
        jmp     saveexit        ; and return
;
; normal return
save1:
        call    comoff          ; com line off
        call    flushit         ; flush the buffer
        jc      exception       ; error?
        call    closefile       ; close the file
        jc      exception       ; error?
        jmp     saveexit        ; exit
;
; common return
saveexit:
        call    comon           ; com line on
        ret
;
save    endp
codes   ends                    ; end of code segment
        end     save