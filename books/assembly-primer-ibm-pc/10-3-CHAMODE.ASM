;CHAMODE--Program to change screen modes

key_in  equ     1h  ;keyboard input
pstring equ     9h  ;print string
doscall equ     21h ;DOS interrupt number

;*********************************************

;SEGMENT TO CONTAIN EQUIPMENT FLAG

rom_da  segment at  40h
        org     10h
eq_flag dw      ?
rom_da  ends
;*********************************************

codeseg segment         ;define code segment

        assume  cs:codeseg
        assume  ds:codeseg

        org 100h
start:

;print intro message
        mov     dx,offset mess  ;addr of mess
        mov     ah,pstring  ;print string function
        int     doscall     ;call DOS

;set data segment to equipment flag
        assume  ds:rom_da
        mov     ax,rom_da   ;set DS to
        mov     ds,ax       ;equipment flag

;get input letter
        mov     ah,key_in   ;keyboard input
        int     doscall     ;call DOS
        cmp     al,'m'      ;is it "m" ?
        je      mono        ;monochrome
        cmp     al,'h'      ;is it "h" ?
        je      hi_res      ;hi res blk and white
        cmp     al,'c'      ;is it "c" ?
        je      color       ;320x200 color
        jmp     start       ;unknown input

;SET UP FOR MONOCHROME DISPLAY
mono:
        mov     ax,eq_flag   ;get equipment flag
        and     ax,11001111b ;mask off video bits
        or      ax,00110000b ;monochrome bits
        mov     eq_flag,ax   ;back into flag

        mov     al,2        ;80 column b & w code
        mov     ah,0        ;"setmode" function
        int     10h         ;call Video BIOS
        jmp     exit

;SET UP FOR 640 X 200 BLACK AND WHITE
hi_res:
        mov     ax,eq_flag   ;get equipment flag
        and     ax,11001111b ;mask off video bits
        or      ax,00100000b ;color card 80 x 25
        mov     eq_flag,ax   ;back into flag

        mov     al,6        ;640x200 bl & white
        mov     ah,0        ;"set mode" function
        int     10h         ;call Video BIOS
        jmp     exit

;SET UP FOR 320 X 200 COLOR MODE
color:
        mov     ax,eq_flag   ;get equipment flag
        and     ax,11001111b ;mask off video bits
        or      ax,00100000b ;monochrome bits
        mov     eq_flag,ax   ;back into flag

        mov     al,4        ;320x200 color
        mov     ah,0        ;"set mode" function
        int     10h         ;call Video BIOS
        jmp     exit

exit:
        int     20h         ;return to DOS

;SIGN-ON MESSAGE

mess    db  13,10
        db  'Type "m" for 80x25 monochrome',13,10
        db  '     "h" for 640x200 b & w',13,10
        db  '     "c" for 320x200 color',13,10
        db  'Selection: $'

codeseg ends
;*********************************************

        end     start