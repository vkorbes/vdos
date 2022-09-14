; EXAMPLE PROGRAM 4
;
;----------------------- externals begin -----------------------------+
        extrn   stdout:far
;----------------------- externals end -------------------------------+
;
;----------------------- code area starts ----------------------------+
codes   segment
;
        assume  cs:codes
;----------------------- routine begins ------------------------------+
; ROUTINE TO CONVERT FROM INTERNAL 16-BIT BINARY TO ASCII BINARY
;
bin16out        proc    far
;
; a binary number is in DX
;
        push    cx              ; save registers
        push    ax
;
        mov     cx,16           ; loop for a count of 16
bin16out1:
        rol     dx,1            ; rotate DX left once
        mov     al,dl           ; move into AL
        and     al,1            ; just keep digit
        add     al,30h          ; add 30h to AL
        call    stdout          ; send it out
        loop    bin16out1
;
        pop     ax              ; restore registers
        pop     cx
        ret                     ; return
;
bin16out        endp
;----------------------- routine ends --------------------------------+
;
;----------------------- main program begins -------------------------+
; PROGRAM TO INTERFACE BETWEEN BASIC AND ASSEMBLY LANGUAGE
;
main    proc    far
;
start:
        push    bp              ; save BP register
        mov     bp,sp           ; point BP to stack
;
        mov     bx,[bp+6]       ; get address of data
        mov     dx,[bx]         ; get the data
        call    bin16out        ; convert to binary
;
        pop     bp              ; restore BP
        ret     2               ; return skipping the data
main    endp
;----------------------- main program ends ---------------------------+
codes   ends
;----------------------- code area ends ------------------------------+
        end     start