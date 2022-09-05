;SAVEIMAG--Save image of screen memory on disk
;  in text form ("attributes" not saved)

c_count equ     2000d       ;number of orig chars
new_cnt equ     2050d       ;include rets & lfs
ch_line equ     80d         ;chars per output line
r_size  equ     80h         ;record size
f_size  equ     new_cnt/r_size ;number of recs

doscall equ     21h         ;DOS interrupt number
create  equ     16h         ;create file function
close_f equ     10h         ;Close File function
print_m equ     9h          ;print message function
block_w equ     28h         ;rand blk write func
set_dta equ     1ah         ;set Disk Transfer Addr

fcb     equ     5ch         ;File Control Block
screen  equ     0b000h      ;segment of screen mem

eof     equ     1ah         ;end-of-file character
car_ret equ     0dh         ;carriage return char
l_feed  equ     0ah         ;linefeed character

;*********************************************

stacker segment stack   ;define stack segment

        db      40h dup ('stack...')
stacker ends
;*********************************************

datarea segment         ;define data segment

;these items are in the "program segment
;   prefix" segment

        org     6ah
r_field dw      ?           ;rec size field in FCB
        org     7ch
r1      dw      ?           ;random rec size (low)
r2      db      ?           ;random rec size (high)

        org     80h
buffer  db  new_cnt dup (?)

;these items are in the datarea segment

mess1   db      'No space on disk.$'

datarea ends
;*********************************************

video   segment         ;define extra segment
vid_1   db      (?)
video   ends
;*********************************************

pro_nam segment         ;define code segment

;---------------------------------------------

main    proc    far     ;main part of program

        assume  cs:pro_nam,ds:datarea
        assume  ss:stacker,es:video

start:          ;starting execution address

;set up stack for return
        push    ds          ;save DS
        sub     ax,ax       ;set AX to zero
        push    ax          ;put zero on stack

;MOVE TEXT IN SCREEN MEMORY TO BUFFER

;set up screen pointer
        push    ds          ;screen memory address
        mov     es,ax       ; into ES
        mov     si,0        ;0 in screen pointer

;set up buffer pointer
        mov     di,0        ;0 in buffer pointer

;set up count
        mov     cx,c_count  ;chars in screen mem
        mov     dh,ch_line  ;set chars/line count

;transfer the characters from screen to buffer
transfer:
        mov     al,[vid_1 + si]  ;char from screen
        inc     si               ;bump screen pointer
        inc     si               ;  twice
        mov     [buffer + di],al ;put char in buff
        inc     di               ;bump buff pointer once

;if at end of line (multiple of 80d chars),
;  then insert return and linefeed in buffer

        dec     dh          ;done this line?
        jnz     no_return   ;not yet, do next char

        mov     [buffer + di],car_ret ;insert ret
        inc     di                    ;bump pointer
        mov     [buffer + di],l_feed  ;insert lf
        inc     di
        mov     dh,ch_line            ;reset chars/line count

no_return:
        loop    transfer    ;get next character

;CREATE THE FILE

        mov     dx,fcb      ;put FCB addr in DX
        mov     ah,create   ;create file function
        int     doscall     ;call DOS
        inc     al          ;if AL was FF, then
        je      no_space    ;   no space to write

;SET RANDOM RECORD FIELD

        mov     r1,0        ;low word
        mov     r2,0        ;high bnyte

;WRITE BLOCK TO DISK

        mov     cx,f_size   ;put file size in CX
        mov     dx,fcb      ;put FCB address in DX
        mov     ah,block_w  ;block write function
        int     doscall     ;call DOS
        or      al,al       ;check if write is o.k.
        jnz     no_space    ;if AL not 0, bad write

;CLOSE FILE

        mov     dx,fcb      ;put FCB addr in DX
        mov     ah,close_f  ;close file function
        int     doscall     ;call DOS

exit:   ret                 ;return to DOS

;PRINT OUT MESSAGE

no_space:
        mov     dx,offset mess1 ;get message
        push    ds          ;save old value of DS
        mov     ax,datarea  ;put seg addr of
        mov     ds,ax       ;   datarea in DS
        mov     ah,print_m  ;print message function
        int     doscall     ;call DOS
        pop     ds          ;restore value of DS
        jmp     exit

main    endp    ;end of main part of program
;---------------------------------------------
pro_nam ends    ;end of code segment
;*********************************************

        end     start       ;end of assembly