; EXAMPLE PROGRAM 1
;
;----------------------- equates begin -------------------------------+
cr      equ     13              ; carriage return
lf      equ     10              ; linefeed
;----------------------- equates end ---------------------------------+
;
;----------------------- stack area begins ---------------------------+
stacks  segment stack           ; stack segment starts here
        dw      5 dup (0)       ; reserve 5 levels of stack with zeros
stacks  ends                    ; stack segment ends here
;----------------------- stack area ends -----------------------------+
;
;----------------------- data area begins ----------------------------+
datas   segment public          ; data segment starts here
;
; MESSAGES
menu    db      cr,lf,'Message Demonstration Program',cr,lf
        db      cr,lf,'Press 1 or 2 for messages or CTRL/C to stop:'
        db      0
mess 1  db      cr,lf,'message number one',cr,lf,0
mess 2  db      cr,lf,'message number two',cr,lf,0
mess 3  db      cr,lf,'You hit an invalid key',cr,lf,0
;
;----------------------- data area ends ------------------------------+
;
;----------------------- code area starts ----------------------------+
codes   segment
;
        assume  cs:codes,ss:stacks,ds:datas
;----------------------- routine begins ------------------------------+
; ROUTINE FOR STANDARD INPUT WITH ECHO
;
stdin   proc    far
        mov     ah,1        ; standard input
        int     21h         ; DOS call
        ret                 ; return
stdin   endp
;----------------------- routine ends --------------------------------+
;
;----------------------- routine begins ------------------------------+
; ROUTINE FOR STANDARD OUTPUT
;
stdout  proc    far
        push    dx          ; save registers
;
        mov     dl,al       ; in DL for DOS call
        mov     ah,2        ; standard output
        int     21h         ; DOS call
;
        pop     dx          ; restore registers
        ret                 ; return
stdout  endp
;----------------------- routine ends --------------------------------+
;
;----------------------- routine begins ------------------------------+
; RETURN TO SEND MESSAGE TO STANDARD OUTPUT
;
stdmessout  proc    far
        push    si              ; save registers
        push    ax
;
stdmessout1:
        mov     al,[si]         ; get byte
        inc     si              ; point to next byte
        cmp     al,0            ; done?
        je      stdmessoutexit  ; if so exit
        call    stdout          ; send it out
        jmp     stdmessout1     ; loop for more
;
stdmessoutexit:
        pop     ax              ; restore registers
        pop     si
        ret                     ; return
stdmessout      endp
;----------------------- routine ends --------------------------------+
;
;----------------------- main program begins -------------------------+
; PROGRAM TO INTERACTIVELY DISPLAY MESSAGES
;
main    proc    far
;
start:
        mov     ax,datas        ; get data segment
        mov     ds,ax           ; put into DS
;
main0:
        lea     si,menu         ; point to menu message
        call    stdmessout      ; send the message
;
        call    stdin           ; get key from user
main1:
        cmp     al,'1'          ; message number 1?
        jne     main2           ; skip if not
        lea     si,mess1        ; point to message 1
        call    stdmessout      ; send the message
        jmp     main4           ; exit to bottom of loop
main2:
        cmp     al,'2'          ; message number 2?
        jne     main3           ; skip if not
        lea     si,mess2        ; point to message 2
        call    stdmessout      ; send the message
        jmp     main4           ; exit to bottom of loop
main3:
        lea     si,menu3        ; point to message 3
        call    stdmessout      ; send the message
;
main4:
        jmp main0               ; another message
;
main    endp
;----------------------- main program ends ---------------------------+
codes   ends
;----------------------- code area ends ------------------------------+
        end     start