;DRAWLINE--Program to draw diagonal lines
;          Uses ROM routines

;For 320x200 color graphics modes

;*********************************************

datarea segment         ;define data segment

delta_x dw      ?       ; |x2-x1|
delta_y dw      ?       ; |y2-y1|
halfy   label   word    ; |y2-y1| / 2
halfx   dw      ?       ; |x2-x1| / 2
count   dw      ?       ; set to long axis

x1      dw      ?       ; first X coordinate
y1      dw      ?       ; first Y coordinate
x2      dw      ?       ; second X coordinate
y2      dw      ?       ; second Y coordinate
color   dw      ?       ; color, 0-1 or 0-4

datarea ends
;*********************************************

pro_nam segment         ;define code segment

;---------------------------------------------
main    proc    far     ;main part of program

        assume  cs:pro_nam,ds:datarea

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

;SET UP BEGINNING AND END OF LINE
;  AND CALL LINESUB TO DRAW LINE

newline:
        call    decibin     ;x1
        mov     x1,bx
        call    decibin     ;y1
        mov     y1,bx
        call    decibin     ;x2
        mov     x2,bx
        call    decibin     ;y2
        mov     y2,bx
        call    decibin     ;color
        mov     color,bx

call    linesub             ;draw line

jmp     newline             ;do it again

main    endp    ;end of main part of program
;---------------------------------------------
linesub proc    near

;LINESUB--SUBROUTINE TO DRAW LINE
;
;Input is x1, y1  (start of line)
;         x2, y2  (end of line)
;         color  (0-1 or 0-4)


;find |y2-y1| -- result is delta_y
        mov     ax,y2       ;get y2
        sub     ax,y1       ;subtract y1
                            ;result in AX
;figure out if delta_y is positive or negative
;  SI=1 if positive, SI=-1 if negative
        mov     si,1        ;set flag to positive
        jge     store_y     ;  keep it that way
        mov     si,-1       ;set flag to negative
        neg     ax          ;set to abs value
store_y:
        mov     delta_y,ax  ;store delta_y

;find |x2-x1| -- result is delta_x
        mov     ax,x2       ;get x2
        sub     ax,x1       ;subtract x1
                            ;result in AX
;figure out if delta_x is positive or negative
;  DI=0 if positive, DI=1 if negative
        mov     di,1        ;set flag to positive
        jge     store_x     ;  keep it that way
        mov     di,-1       ;set flag to negative
        neg     ax          ;set to abs value
store_x:
        mov     delta_x,ax  ;store delta_x

;figure out if slope is greater or less than 1
        mov     ax,delta_x  ;get delta_x
        cmp     ax,delta_y  ;compare deltas
        jl      csteep      ;slope > 1
        call    easy        ;slope < 1, or = 1
        jmp     finish

csteep:
        call steep          ;slope > 1

;DONE LINE--RETURN
finish:
        ret

linesub endp
;---------------------------------------------
easy    proc    near

;SLOPE < 1

;calculate half of delta_x, call it halfx
        mov     ax,delta_x  ;get |x2-x1|
        shr     ax,1        ;shift right to divide
        mov     halfx,ax    ;  by 2

;initialize values

        mov     cx,x1       ;set x1
        mov     dx,y1       ;set y1
        mov     bx,0        ;initialize BX
        mov     ax,delta_x  ;set count
        mov     count,ax    ;  to |x2-x1|
newdot:
        call    dotplot     ;plot the dot
        add     cx,di       ;inc/dec X
        add     bx,delta_y  ;add |y2-y1| to BX
        cmp     bx,halfx    ;compare to |x2-x1| /2
        jle     dcount      ;  (don't inc/dec Y)
        sub     bx,delta_x  ;subtract |x2-x1|
                            ;  from BX
        add     dx,si       ;inc/dec Y
dcount:
        dec     count       ;done line yet?
        jge     newdot      ;not yet

        ret                 ;done line

easy    endp
;---------------------------------------------
steep   proc    near

;SLOPE > 1

;calculate half of delta_y, call it halfy
        mov     ax,delta_y  ;get |y2-y1|
        shr     ax,1        ;shift right to divide
        mov     halfy,ax    ;  by 2

;initialize values
        mov     cx,x1       ;set x1
        mov     dx,y1       ;set y1

        mov     bx,0        ;initialize BX
        mov     ax,delta_y  ;set count
        mov     count,ax    ;  to x2-y1

newdot2:
        call    dotplot     ;plot the dot
        add     dx,si       ;inc/dec Y
        add     bx,delta_y  ;add |x2-x1| to BX
        cmp     bx,halfy    ;compare to |y2-y1| /2
        jle     dcount2     ;don't inc/dec X
        sub     bx,delta_x  ;subtract |y2-y1|
                            ;  from BX
        add     cx,di       ;inc/dec X

        ret                 ;return to main dline

steep   endp
;---------------------------------------------
dotplot proc    near

;SAVE REGISTERS AND CALL PLOT ROUTINE

        push    bx          ;save registers
        push    cx
        push    dx
        push    ax
        push    si
        push    di

;use ROM routine to write dot
;requires row # in DX, col in CX, color in AL

        mov     ax,color    ;set color value
        mov     ah,12d      ;write dot function
        int     10h         ;video BIOS routine

        pop     di          ;restore registers
        pop     si
        pop     ax
        pop     dx
        pop     cx
        pop     bx

        ret                 ;return

dotplot endp
;---------------------------------------------
;
key_in  equ     1h          ;keyboard input
doscall equ     21h         ;DOS interrupt number
;
decibin proc    near
;
;SUBROUTINE TO CONVERT DEC ON KEYBD TO BINARY
;   result is left in BX register
;
        mov     bx,0        ;clear BX for number
;
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
pro_nam ends        ;end of code segment
;*********************************************

        end     start       ;end assembly