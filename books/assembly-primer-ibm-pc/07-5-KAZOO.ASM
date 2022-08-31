;KAZOO--Uses Timer2 to run speaker
;  produces variable-pitch sounds

portB   equ     61h     ;I/O Port B
keybd2  equ     7h      ;keybd input, no echo
status  equ     0bh     ;check kbd status
doscall equ     21h     ;DOS interrupt number

;*********************************************
prognam segment ;define code segment

;---------------------------------------------
main    proc    far     ;main part of program

        assume  cs:program

        org     100h    ;start of program

start:          ;starting execution address

;initial values
        mov     bx,500h ;set 1/pitch in BX
        mov     dl,0    ;set pitch change to 0
        mov     dh,3    ;set on/off status on

sounder:
        mov     al,10110110b    ;put magic number
        out     43h,al          ;  into timer2

tone:
        mov     ax,bx   ;move 1/pitch into AX
        out     42h,al  ;LSB into timer2
        mov     al,ah   ;MSB to AL, then
        out     42h,al  ;  to timer2

        in      al,portB     ;read port B into AL
        and     al,11111100b ;mask off bits 0, 1
        add     al,dh        ;add on/off status
        out     portB,al     ;to turn speakr on/off

;raise or lower pitch by amount in AX
        mov     al,bh   ;divide BX by 100h
        mov     ah,0    ;top half of AX = 0
        or      ax,1    ;make sure at least 1
        or      dl,dl   ;does DL = 0 ?
        jz      skip    ;  if so, AX is plus
        neg     ax      ;make AX negative
skip:   add     bx,ax   ;add change to pitch

        mov     cx,200h ;set up wait loop
wait:   loop    wait    ;  loop a while

        mov     ah,status   ;check status function
        int     doscall     ;call DOS

        inc     al          ;if AL was FF, then
        jz      read_key    ;  character was typed
        jmp     tone        ;sound tone again

;read keyboard to get digit
; 1=lower pitch, 2=raise pitch, 9=on, 0=off

read_key:
        mov     ah,keybd2   ;keybd funct, no echo
        int     doscall     ;call DOS
        cmp     al,'1'      ;is it 1 ?
        jz      lower       ;  lower pitch
        cmp     al,'2'      ;is it 2 ?
        jz      higher      ;  raise pitch
        cmp     al,'9'      ;is it 9 ?
        jz      turn_on     ;  turn on tone

        cmp     al,'0'      ;is it 0 ?
        jz      turn_off    ;  turn off tone
        jmp     tone        ;not recognized

lower:
        mov     dl,0
        jmp     tone
higher:
        mov     dl,+1
        jmp     tone
turn_on:
        mov,    db,00000011b
        jmp     sounder
turn_off:
        mov     dh,0
        jmp     sounder

main    endp    ;end of main part of program
;---------------------------------------------

prognam ends    ;end of code segment
;*********************************************

        end     start   ;end assembly