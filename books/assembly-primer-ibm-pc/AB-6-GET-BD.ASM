;GET-BD--Program to search file for names
;        with today's birthday

;name of file must follow "get-bd".   E.g.:
;          A>get-bd birthday.txt
;if no matches, nothing will be printed

;uses sequential read

doscall equ     21h         ;DOS interrupt number
open_f  equ     0fh         ;Open File function
r_seq   equ     14h         ;Read Sequential rec
display equ     2h          ;display output funct
g_date  equ     2ah         ;get date function
name_sz equ     21d         ;max length of name
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
max_cnt db      name_sz     ;max length of name

        org     80h         ;data transfer area
count   db      ?           ;filled in by buff_in
bname   db      name_sz dup (?) ;buffer for name
month   db      ?           ;byte for month
day     db      ?           ;byte for day

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
        jnz     done        ;can't find file

;SET RECORD SIZE, RECORD NUMBER

        mov     r_field,rec_sz  ;set size of record
        mov     recno,0         ;set record count to 0

;READ RECORD FROM DISK INTO BUFFER

next_rec:
        mov     dx,fcb      ;FCB address in DX
        mov     ah,r_seq    ;Read Sequential rec
        int     doscall     ;call DOS
        or      al,al       ;end-of-file? (AL<>0)?
        jnz     done        ;yes, so we're done

;GET MONTH AND DAY FROM INTERNAL CLOCK

        mov     ah,g_date   ;get date function
        int     doscall     ;call DOS

;COMPARE MONTH AND DAY IN RECORD WITH
;        CURRENT MONTH AND DAY
        cmp     month,dh    ;DH is current month
        jnz     next_rec    ;no match; get next rec
        cmp     day,dl      ;DL is current day
        jnz     next_rec    ;no match; get next rec

;MONTH AND DAY MATCH, SO PRINT NAME
        mov     cl,count    ;letter count in CX
        mov     ch,0        ; (zero out top half)
        mov     bx,offset bname ;start of buffer
new_char:
        mov     dl,[bx]     ;get char from buffer
        mov     ah,display  ;display char function
        int     doscall     ;call DOS
        inc     bx          ;bump pointer
        loop    new_char    ;do until CX=0

        call    crlf        ;new line
        jmp     next_rec    ;get next record

;DONE, SO RETURN TO DOS

done:
        ret                 ;return to DOS

main    endp    ;end of main part of program
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