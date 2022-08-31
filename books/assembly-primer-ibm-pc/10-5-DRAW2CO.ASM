;DRAW2CO--Program to draw on screen with
;         cursor arrows. Uses internal
;         subroutine to plot dot

;For 320 x 200 medium res color mode
;
up      equ 48h     ;scan code for up arrow
down    equ 50h     ;scan code for down arrow
right   equ 4dh     ;scan code for right arrow
left    equ 4bh     ;scan code for left arrow
;
escape  equ 1bh     ;"escape" character
;
;*********************************************

video   segment at 0b800h   ;define extra seg
wd_buff label   word
v_buff  label   byte
video   ends
;*********************************************

pro_nam segment         ;define code segment

;---------------------------------------------
main    proc    far     ;main part of program

        assume  cs:pro_nam,es:video

start:          ;starting execution address

;set up stack for return
        push    ds          ;save DS
        sub     ax,ax       ;set AX to zero
        push    ax          ;put it on stack

;set extra segment to video memory
        mov     ax,video    ;get video address
        mov     es,ax       ;  put in ES

;clear screen by scrolling it, using ROM call

        mov     ah,6        ;scroll up function
        mov     al,0        ;code to blank screen
        mov     cx,0        ;upper left = 0,0
        mov     dl,79       ;lower right corner
        mov     dh,24       ; at 79,25
        int     10h         ;call video interrupt

;screen pointer will be in CX register
;  row    number (0 to 200d) in DX
;  column number (0 to 320d) in CX

;set screen pointer to center of screen
        mov     dx,100d  ;# rows divided by 2
        mov     cx,160d  ;# columns div by 2

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
    
;number from 0 to 3, so it is a color value
        and     al,3        ;mask off upper 5 bits
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

;call PLOTSUB routine to write dot
;requires row # in DX, col in CX, color in AL
lite_it:
        mov     al,bl       ;put color back in AL
        call    plotsub     ;write dot
        jmp     get_char    ;go get next arrow
exit:   ret                 ;return to DOS

main    endp    ;end of main part of program

;---------------------------------------------
plotsub proc    near

;SUBROUTINE TO PLOT A POINT ON SCREEN
;       Medium res graphics mode
;       320 x 200 color
;Enter with:
;   X-coordinate in CX (column number: 0-319)
;   Y-coordinate in DX (row number: 0-199)
;   color in AL (0=off, 1,2,3=colors)

        push    bx          ;save BX
        push    cx          ;save column
        push    dx          ;save row
        push    ax          ;save color

;multiply the row number by # of bytes per row
; (80, but since already mult by 2, use 40)
        push    dx          ;save row for odd/even
        mov     al,40       ;bytes/row div by 2
        and     dx,0feh     ;mask off odd/even bit
        mul     dl          ;AX now is row address

;figure out if we should add 2000h for 2nd
;  memory bank, if odd row number
        pop     dx          ;get original row #
        test    dl,1        ;test odd/even bit
        jz      not_odd     ;jump on even row
        add     ax,2000h    ;add to get 2nd bank

not_odd:
        mov     bx,ax       ;save row addr in BX

;add column address to row address
        push    cx          ;save column address
        shr     cx,1        ;shift it right to
        shr     cx,1        ;  kill BIT-POS bits
        add     bx,cx       ;add it to addr in BX

;use BIT-POS bits to put COLOR and MASK in
;   the right position
        pop     cx          ;get original col #
        and     cx,3        ;save BIT-POS bits
        inc     cx          ;get one free shift
        pop     ax          ;get color
        mov     dl,0fch     ;DL=mask:   11,11,11,00
shift:                      ;AL=color:  00,00,00,cc
        ror     al,1        ;shift color
        ror     al,1        ;   two bits right
        ror     dl,1        ;shift mask
        ror     dl,1        ;   two bits right
        loop    shift       ;do it BIT-POS times

;get contents of byte, mask off all but color
;  bits, OR on color bits.

        and     [v_buff + bx],dl    ;mask off
        or      [v_buff + bx],al    ;OR on color

        pop     dx          ;restore row
        pop     cx          ;restore column
        pop     bx          ;restore BX
        ret                 ;return

plotsub endp
;---------------------------------------------
pro_nam ends        ;end of code segment
;*********************************************

        end     start       ;end assembly