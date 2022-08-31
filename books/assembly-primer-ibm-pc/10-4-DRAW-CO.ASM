;DRAW-CO--Program to draw on screen with
;         cursor arrows. Uses ROM routines

;For 320 x 200 medium res color mode
up      equ 48h     ;scan code for up arrow
down    equ 50h     ;scan code for down arrow
right   equ 4dh     ;scan code for right arrow
left    equ 4bh     ;scan code for left arrow
escape  equ 1bh     ;"escape" character

;*********************************************

pro_nam segment         ;define code segment

;---------------------------------------------
main    proc    far     ;main part of program

        assume  cs:pro_nam

start:          ;starting execution address

;set up stack for return
        push    ds          ;save DS
        sub     ax,ax       ;set AX to zero
        push    ax          ;put it on stack

;clear screen by scrolling it, using ROM call

        mov     ah,6        ;scroll up function
        mov     al,0        ;code to blank screen
        mov     cx,0        ;upper left = 0,0
        mov     dl,79       ;lower right corner
        mov     dh,24       ; at 79,25
        int     10h         ;call video interrupt

;set screen pointer to center of screen
        mov     dx,100d     ;# rows divided by 2
        mov     cx,160d     ;# columns div by 2
;get character from keyboard, using ROM BIOS
;  routine

get_char:
        mov     ah,0        ;code for read char
        int     16h         ;keyboard I/O ROM call
        cmp     al,escape   ;is it control-C?
        jz      exit        ;yes

        cmp     al,33h      ;is it more than "3"
        jg      plot_it     ;yes, not a color
        cmp     al,30h      ;is it less than "0"
        jl      plot_it     ;yes, not a color
        mov     bl,al       ;save it in BL
        jmp     get_char    ;get next character

;figure out which way to go, and draw new line
plot_it:
        mov     al,ah       ;put scan code in AL
        cmp     al,up       ;is it UP arrow?
        jnz     not_up      ;no
        dec     dx          ;yes, decrement row
not_up:
        cmp     al,down     ;is it DOWN arrow?
        jnz     not_down    ;no
        inc     dx          ;yes, increment row
not_down:
        cmp     al,right    ;is it RIGHT arrow?
        jnz     not_right   ;no
        inc     cx          ;yes, increment column
not_right:
        cmp     al,left     ;is it LEFT arrow?
        jnz     lite_it     ;no
        dec     cx          ;yes, decrement column

;use ROM routine to write dot
;requires row # in DX, col in CX, color in AL
        mov     al,bl       ;set color value
        mov     ah,12d      ;write dot function
        int     10h         ;video BIOS routine

        jmp     get_char    ;go get next arrow

exit:   ret                 ;return to DOS

main    endp    ;end of main part of program
;---------------------------------------------
pro_nam ends        ;end of code segment
;*********************************************

        end     start       ;end assembly