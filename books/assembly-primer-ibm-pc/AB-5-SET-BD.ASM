;SET-BD--Program to write name and birthday
;          to file

;name of file must follow "set-bd",
;          as in A>set-bd birthday.txt

;asks for name, and day and month of birthday
;writes this information as one record of file
;   record is 22d bytes long
;repeat as often as necessary
;terminate with enter for name
;NOTE: program can only be used ONCE PER FILE
;uses Sequential Write DOS function

doscall equ     21h         ;DOS interrupt number
create  equ     16h         ;Create File function
w_seq   equ     15h         ;Write Sequential rec
close_f equ     10h         ;Close File function
print_m equ     9h          ;print message function
buff_in equ     0ah         ;buffered keybd input
key_in  equ     1h          ;keybd input (1 char)
display equ     2h          ;display output funct
name_sz equ     21h         ;max length of name
rec_sz  equ     name_sz+3   ;name plus 3 bytes
fcb     equ     5ch         

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

mess1   db      'Enter name: $'
mess2   db      'Enter month of birth (1-12): $'
mess3   db      'Enter day of birth (1-31): $'

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

;CREATE FILE

        mov     dx,fcb      ;FCB address in DX
        mov     ah,create   ;Create File function
        int     doscall     ;call DOS
        or      al,al       ;see if found (AL=0)?
        jnz     done        ;no room in directory

;SET RECORD SIZE, RECORD NUMBER

        mov     r_field,rec_sz  ;set size of record
        mov     recno,0         ;set record count to 0

;GET INFORMATION FROM USER
next_rec:

;print "name" message
        mov     dx,offset mess1 ;addr in DX
        call    p_mess          ;print message

;set maximum name size in input buffer
        mov     max_cnt,name_sz

;get name
        mov     dx,offset buffer    ;set addr of buff
        mov     ah,buff_in      ;keyboard input funct
        int     doscall         ;call DOS
        call    crlf            ;new line

;check if name has no characters (user is done)
        mov     al,count        ;get # of chars input
        or      al,al           ;is it zero?
        jz      done            ;yes, user is done

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

;DONE, SO CLOSE FILE, RETURN TO DONE

done:
        mov     dx,fcb      ;FCB address in DX
        mov     ah,close_f  ;Close File function
        int     doscall     ;call DOS
        ret                 ;return to DOS

main    endp    ;end of main part of program
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