        name    zdivide
        page    55,132
        title   'ZERODIV.ASM --- Divide by Zero Handler'
















cr      equ     0dh
lf      equ     0ah
beep    equ     07h
backsp  equ     08h

cseg    segment para public 'CODE'

        org     100H
       
        assume  cs:cseg,ds:data,ss:stack

Init    proc    near

        mov     dx,offset Zdiv
        mov     ax,2500h
        int     21h


        mov     dx,offset signon
        mov     ax,9
        int     21h



        mov     dx,((offset Pgm_Len+15)/16+10h

        mov     ax,3100h
        int     21h

Init    endp

Zdiv    proc    far


        sti
        push    ax
        push    bx
        push    cx
        push    dx
        push    si
        push    di
        push    bp
        push    ds
        push    es

        mov     ax,cs
        mov     ds,ax
        mov     dx,offset warn
        mov     ah,9
        int     21h

Zdiv1:  mov     ah,1
        int     21h

        cmp     al,'C'
        je      Zdiv3
        cmp     al,'Q'
        je      Zdiv2

        mov     dx,offset bad
        mov     ah,9
        int     21h

        jmp     Zdiv1

Zdiv2:  mov     ax,4cffh
        int     21h


Zdiv3:  mov     dx,offset crlf
        mov     ah,9
        int     21h

        pop     es
        pop     ds
        pop     bp
        pop     di
        pop     si
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        iret

Zdiv    endp

signon  db      cr,lf,'Divide by Zero Interrupt '
        db      'Handler installed.'
        db      cr,lf,'$'

warn    db      cr,lf,lf,'Divide by Zero detected: '
        db      cr,lf,'Continue or Quit (C/Q) ? '
        db      '$'

bad     db      beep,backsp,' ',backsp,'$'

crlf    db      cr,lf,'$'

Pgm_Len equ     $-Init

cseg    ends

        end     init