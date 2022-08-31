;DRAW-1--Program to draw on screen with
;         cursor arrows. Uses ROM routines
read_c  equ 0h      ;read character code
key_rom equ 16h     ;ROM keyboard routine
up      equ 48h     ;scan code for up arrow
down    equ 50h     ;scan code for down arrow
right   equ 4dh     ;scan code for right arrow
left    equ 4bh     ;scan code for left arrow
block   equ 0dbh    ;solid graphics character
ctrl_C  equ 3h      ;control-C (break) char
;*********************************************
video   segment at 0b000h   ;define extra seg
wd_buff label   word
v_buff  db      25 * 80 * 2 dup (?)

video   ends
;*********************************************
pro_nam segment         ;define code segment
;---------------------------------------------
main    proc    far     ;main part of program
        assume  cs:program
        assume  es:video
start:          ;starting execution address
;set up stack for return
        push    ds          ;save DS
        sub     ax,ax       ;set AX to zero
        push    ax          ;put it on stack
;set ES to extra segment
        mov     ax,video
        mov     es,ax
;clear screen by writing zeros to it
;   even bytes get 0 (character)
;   odd bytes get 7 (normal "attribute")
        mov     cx, 80 * 25     ;count
        mov     bx,0            ;start of buff
clear:  mov     [wd_buff + bx], 0700h
        inc     bx              ;incr pointer
        inc     bx              ;  twice
        loop    clear           ;do again
;screen pointer will be in CX register
;  row    number (0 to 24d) in CH
;  column number (0 to 79d) in CL
;set screen pointer to center of screen
        mov     ch,12h  ;# rows divided by 2
        mov     cl,40d  ;# columns div by 2
;get character from keyboard, using ROM BIOS
;  routine
get_char:
        mov     ah,read_c   ;code for read char
        int     key_rom     ;keyboard I/O ROM call
        cmp     al,ctrl_C   ;is it control-C?
        jz      exit        ;yes
        mov     al,ah       ;put scan code in AL
        cmp     al,up       ;is it UP arrow?
        jnz     not_up      ;no
        dec     ch          ;yes, decrement row
not_up:
        cmp     al,down     ;is it DOWN arrow?
        jnz     not_down    ;no
        inc     ch          ;yes, increment row
not_down:
        cmp     al,right    ;is it RIGHT arrow?
        jnz     not_right   ;no
        inc     ch          ;yes, increment column
not_right:
        cmp     al,left     ;is it LEFT arrow?
        jnz     not_left    ;no
        inc     ch          ;yes, decrement column
lite_it:
        mov     al,160d     ;bytes per row into AL
        mul     ch          ;times # of rows
                            ;  result in AX
        mov     bl,cl       ;# of columns in BL
        rol     bl,1        ;times 2 to get bytes
        mov     bh,0        ;clear top part of BX
        add     bx,ax       ;add AX to it
                            ; gives address offset
;address offset in BX. Put block char there
        mov     al,block
        mov     [v_buff + bx], al
        jmp     get_char    ;go get next arrow
exit:   ret                 ;return to DOS
main    endp    ;end of main part of program
;---------------------------------------------
pro_nam ends        ;end of code segment
;*********************************************
        end     start       ;end assembly