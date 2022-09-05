;MOD-BD--Program to modify or add to info
;        in birthday file

;name of file must follow "mod-bd".  E.g.:
;          A>mod-bd birthday.txt

;file must already have been created by set-bd

;displays contents of each record, asks if user
;    wants to change it

;uses sequential read and write

doscall equ     21h         ;DOS interrupt number
open_f  equ     0fh         ;Open File function
w_seq   equ     15h         ;Write Sequential rec
r_seq   equ     14h         ;Read Sequential rec
close_f equ     10h         ;Close File function
print_m equ     9h          ;print message function
buff_in equ     0ah         ;buffered keybd input
key_in  equ     1h          ;keybd input (1 char)
display equ     2h          ;display output funct
name_sz equ     21h         ;max length of name
rec_sz  equ     name_sz+3   ;name plus 3 bytes
fcb     equ     5ch         ;File Control Block
let_y   equ     79h         ;letter "y"
;*********************************************
datarea segment         ;define data segment

;DEFINE FILE CONTROL BLOCK

        org     6ah         ;record size field
r_field db      ?
        org     7ch         ;record number
recno   db      ?

;DEFINE DATA TRANSFER AREA

        org     7fh         ;input buffer
buffer  label   byte
max_cnt db      name_sz     ;length of name

        org     80h         ;data transfer area
count   db      ?           ;filled in by buff_in
bname   db      name_sz dup (?) ;buffer for name
month   db      ?           ;byte for month
day     db      ?           ;byte for day

;this data is in segment set by LINK to DATAREA

mess0   db      'MODIFY THIS RECORD? (y/n): $'
mess1   db      'Enter name: $'
mess2   db      'Enter month of birth (1-12): $'
mess3   db      'Enter day of birth (1-31): $'
mess4   db      'ADD ANOTHER RECORD? (y/n): $'

datarea ends
;*********************************************

pro_nam segment         ;define code segment

;---------------------------------------------

main    proc    far     ;main part of program

        assume  cs:pro_nam,ds:datarea

;SET UP STACK FOR RETURN
start:          
        push    ds          ;save DS
        sub     ax,ax       ;set AX to zero
        push    ax          ;put zero on stack

;OPEN FILE

        mov     dx,fcb      ;FCB address in DX
        mov     ah,open_f   ;Open File function
        int     doscall     ;call DOS
        or      al,al       ;see if found (AL=0)?
        jz      set_size    ;found OK
        jmp     done        ;no such filename
;(note: this jump too long for "jnz done")

;READ RECORD
next_rec:
        call    crlf        ;print return, linefeed
        mov     dx,fcb      ;FCB address in DX
        mov     ah,r_seq    ;read sequential funct
        int     doscall     ;call DOS
        or      al,al       ;end-of-file? (AL<>0?)
        jz      p_rec       ;no
        jmp     end_file    ;yes
;(note: this jump too long for "jnz end_file")

;PRINT CONTENTS OF RECORD FROM BUFFER
p_rec:

;print name
        mov     cl,count    ;letter count in CX
        mov     ch,0        ;  (zero out top half)
        mov     bx,offset bname ;start of buffer
new_char:
        mov     dl,[bx]     ;get char from buffer
        mov     ah,display  ;display char function
        int     doscall     ;call DOS
        inc     bx          ;bump pointer
        loop    new_char    ;do until CX=0
        call    crlf        ;new line

;print month
        mov     bl,month    ;month from buffer
        mov     bh,0        ;  (zero out top half)
        call    binidec     ;print in decimal
        call    crlf        ;new line

;print day
        mov     bl,day      ;day from buffer
        mov     bh,0        ;  (zero out top half)
        call    binidec     ;print in decimal
        call    crlf        ;new line

;ASK IF USER WANTS TO CHANGE IT

;print "modify?" message
        mov     dx,offset mess0 ;addr in DX
        call    p_mess      ;print message

;get "y" or "n" answer
        mov     ah,key_in   ;keyboard input funct
        int     doscall     ;call DOS
        cmp     al,let_y    ;is it letter "y" ?
        jne     next_rec    ;no, go read next rec
;yes, so user wants to modify record
        dec     recno       ;decrement record #

;GET INFORMATION FROM USER
mod_rec:
        call    crlf        ;print return, linefeed

;print "name" message
        mov     dx,offset mess1 ;addr in DX
        call    p_mess      ;print message

;set maximum name size in input buffer
        mov     max_cnt,name_sz

;get name
        mov     dx,offset buffer ;set addr of buff
        mov     ah,buff_in  ;keyboard input funct
        int     doscall     ;call DOS
        call    crlf        ;new line

;check if name has no characters (user is done)
        mov     al,count    ;get # of chars input
        or      al,al       ;is it zero?
        jz      next_rec    ;yes, get next record

;print "month" message
        mov     dx,offset mess2 ;addr in DX
        call    p_mess          ;print message

;get month
        call    decibin     ;get month
        mov     month,bl    ;put month in buffer
        call    crlf        ;new line

;print "day" message
        mov     dx,offset mess3 ;addr in DX
        call    p_mess          ;print message

;get day
        call    decibin     ;get day
        mov     day,bl      ;put day in buffer
        call    crlf        ;new line

;WRITE RECORD FROM BUFFER TO DISK

        mov     dx,fcb      ;FCB address in DX
        mov     ah,w_seq    ;write sequential func
        int     doscall     ;call DOS
        jmp     next_rec    ;go get next record

;END OF FILE.  SEE IF USER WANTS TO ADD RECORD
end_file:

;print "add another record" message
        mov     dx,offset mess4 ;addr of message
        call    p_mess      ;print message

;get "y" or "n" answer
        mov     ah,key_in   ;keyboard input funct
        int     doscall     ;call DOS
        cmp     al,let_y    ;is it letter "y" ?
        je      next_rec    ;yes, go add new rec
;no, so user is done.

;DONE, SO CLOSE FILE, RETURN TO DONE

done:
        mov     dx,fcb      ;FCB address in DX
        mov     ah,close_f  ;Close File function
        int     doscall     ;call DOS
        ret                 ;return to DOS

main    endp    ;end of main part of program

;---------------------------------------------
;
binidec proc    near
;
;SUBROUTINE TO CONVERT BINARY NUMBER IN BX
;  TO DECIMAL ON CONSOLE SCREEN
;
        mov     cx,10000d   ;divide by 10000
        call    dec_div
        mov     cx,1000d    ;divide by 1000
        call    dec_div
        mov     cx,100d     ;divide by 100
        call    dec_div
        mov     cx,10d      ;divide by 10
        call    dec_div
        mov     cx,1d       ;divide by 1
        call    dec_div
        ret                 ;return from binidec
;
;- - - - - - - - - - - - - - - - - - - - - - -
;
dec_div proc    near
;
;sub-subroutine to divide number in BX by
;  number in CX, print quotient on screen
;
        mov     ax,bx       ;put number in AX
        cwd     ;ax into ax and dx
        div     cx          ;divide by CX
        mov     bx,dx       ;remainder into BX
        mov     dl,al       ;quotient into DL
;
;print the contents of DL on screen
        add     dl,30h      ;convert to ASCII
        mov     ah,display  ;display function
        int     doscall     ;call DOS
        ret                 ;return from dev_div
;
dev_div endp
;- - - - - - - - - - - - - - - - - - - - - - -
;
binidec endp
;---------------------------------------------

;---------------------------------------------
decibin proc    near
;
;SUBROUTINE TO CONVERT DEC ON KEYBD TO BINARY
;   result is left in BX register

        mov     bx,0        ;clear BX for number

;get digit from keyboard, convert to binary
newchar:
        mov  ah,key_in  ; keyboard input
        int  doscall    ; call DOS
        sub  al,30h     ; ASCII to binary
        jl   exit       ; jump if < 0
        cmp  al,9d      ; is it > 9d ?
        jg   exit       ; yes, not dec digit
        cbw  ; byte in AL to word in AX
; (digit is now in AX)
;
;multiply number in bx by 10 decimal
        xchg ax,bx      ; trade digit & number
        mov  cx,10d     ; put 10 dec in CX
        mul  cx         ; number times 10
        xchg ax,bx      ; trade number & digit
;
;add digit in ax to number in bx
        add  bx,ax      ; add digit to number
        jmp  newchar    ; get next digit
exit:
        ret
;
decibin endp
;---------------------------------------------

p_mess  proc    near

;SUBROUTINE TO PRINT MESSAGES
;  enter w address of message in dx

        push    ds          ;save old value of DS
        mov     ax,datarea  ;put new data seg
        mov     ds,ax       ;   in DS
        mov     ah,print_m  ;print message function
        int     doscall     ;call DOS
        pop     ds          ;restore old DS value
        ret

p_mess  endp
;---------------------------------------------

crlf    proc    near

;CRLF--Subroutine to print carriage return
;      and linefeed

        mov     dl,0ah      ;linefeed
        mov     ah,display  ;display function
        int     doscall     ;call DOS

        mov     dl,0ah      ;carriage return
        mov     ah,display  ;display function
        int     doscall     ;call DOS
        ret

crlf    endp
;---------------------------------------------

pro_nam ends                ;end of code segment
;*********************************************
        end     start       ;end of assembly