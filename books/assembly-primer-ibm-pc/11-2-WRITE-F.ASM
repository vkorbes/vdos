;WRITE-F--Writes sequential records

doscall equ     21h     ;DOS interrupt number
create  equ     16h     ;Create File function
writesq equ     15h     ;Write Sequential rec
close   equ     10h     ;Close File function
buffin  equ     0ah     ;buffered kbd input fn
fcb     equ     5ch     ;file control block
return  equ     0dh     ;ASCII carriage return
lfeed   equ     0ah     ;ASCII linefeed
;*********************************************

datarea segment         ;define data segment

        org 7ch
recno   db  ?           ;record number

        org 80h
dta     db  80h dup (?) ;data transfer area

datarea ends
;*********************************************

pro_nam segment         ;define code segment

;---------------------------------------------
main    proc    far     ;main part of program

        assume  cs:pro_nam,ds:datarea

start:          ;starting execution address

;set up stack for return
        push    ds          ;save old data segment
        sub     ax,ax       ;put zero in AX
        push    ax          ;save it on stack

;CREATE DISK FILE, SET RECORD NUMBER TO 0
        mov     dx,fcb      ;set DX to FCB
        mov     ah,create   ;Open File function
        int     doscall     ;call DOS
        mov     recno,0     ;put 0 in 7C

;BLANK BUFFER BY FILLING WITH RETURNS
newline:
        mov     bx,0        ;first char in DTA
        mov     cx,80h      ;CX in character count
erase:
        mov     [bx + dta],return   ;put cr in DTA
        inc     bx          ;advance pointer
        loop    erase       ;repeat until done

;GET LINE FROM KEYBOARD
        mov     dta-2,78    ;set max line length
        mov     dx,offset dta-2 ;addr of buffer
        mov     ah,buffin   ;buffered keybd input
        int     doscall     ;call DOS
        cmp     dta-1,1     ;if no chars typed,
        jle     exit        ;  then exit
;insert linefeed following line of chars
        mov     bl,dta-1    ;put actual char count
        mov     bh,0        ;  into BX
        mov     [dta+bx+1],lfeed ;insert linefeed

;WRITE RECORD TO FILE, sequential mode
        mov     dx,fcb      ;set DX to FCB
        mov     ah,writesq  ;Sequent Write funct
        int     doscall     ;call DOS
        jmp     newline     ;go get another line
    
;CLOSE FILE AND EXIT
exit:
        mov     dx,fcb      ;put FCB address in DX
        mov     ah,close    ;Close File function
        int     doscall     ;call DOS
        ret                 ;return to DOS

main    endp    ;end of main part of program
;---------------------------------------------
pro_nam ends        ;end of code segment
;*********************************************

        end     start       ;end assembly