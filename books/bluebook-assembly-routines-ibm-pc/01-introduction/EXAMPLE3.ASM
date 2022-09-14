; EXAMPLE PROGRAM 3 - I/O MODULE - FILE CHIO.ASM
;
;----------------------- code area starts ----------------------------+
codes   segment
++++++++++++++++++++++++ public declarations start ++++++++++++++++++++
        public  stdin,stdout,stdmessout
++++++++++++++++++++++++ public declarations end ++++++++++++++++++++++
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
codes   ends
;----------------------- code area ends ------------------------------+
        end