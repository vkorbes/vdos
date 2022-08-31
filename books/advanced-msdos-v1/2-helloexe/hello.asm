        name    hello
        page    55,132
        title   'HELLO.EXE ---print Hello on terminal'








cr      equ     0dh
lf      equ     0ah





cseg    segment para public 'CODE'

        assume  cs:cseg,ds:dseg,ss:stack

print   proc    far









        mov     ax,dseg
        mov     ds,ax


        mov     dx,offset message


        mov     ah,9
        int     21h

        mov     ax,4c00h
        int     21h

print   endp


cseg    ends






dseg    segment para 'DATA'

message db      cr,lf,'Hello!',cr,lf,'$'

dseg    ends





stack   segment para stack 'STACK'

        dw      64 dup (?)

stack   ends





        end     print