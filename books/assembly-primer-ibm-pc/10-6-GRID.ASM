;GRID--Program to draw grid on screen
;      Uses ROM routine

;For 320 x 200 medium res color mode

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

;screen pointer will be in CX register
;  row    number (0 to 200d) in DX
;  column number (0 to 320d) in CX

;DRAW HORIZONTAL LINES EVERY 20 PIXELS
        mov     dx,0        ;set to first line

;draw one horizontal line at DX
hline:
        mov     cx,0        ;start of horiz line
hdot:
        mov     al,1        ;set color to 1
        mov     ah,12d      ;write dot function #
        int     10h         ;call Video ROM
        inc     cx          ;next dot
        cmp     cx,300      ;done all dots?
        jl      hdot        ;not yet

;next horizontal line
        add     dx,20       ;advance to next line
        cmp     dx,200      ;off the screen yet?
        jl      hline       ;not yet

;DRAW VERTICAL LINES EVERY 20 PIXELS
        mov     cx,0        ;set to first line

;draw one vertical line at CX
vline:
        mov     dx,0        ;start of vert line
vdot:
        mov     al,2        ;set color to 2
        mov     ah,12d      ;write dot function #
        int     10h         ;call Video ROM
        int     dx          ;next dot
        cmp     dx,180      ;done all dots?
        jl      vdot        ;not yet

;next vertical line
        add     cx,20       ;advance to next line
        cmp     cx,320      ;off the screen yet?
        jl      vline       ;do next line

        ret                 ;return to DOS


main    endp    ;end of main part of program
;---------------------------------------------
pro_nam ends    ;end of code segment
;*********************************************

        end     start       ;end assembly