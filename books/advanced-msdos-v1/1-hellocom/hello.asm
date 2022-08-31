        name    hello
        page    55,132
        title   'HELLO.COM ---print Hello on terminal'







cr      equ     0dh             ; ASCII carriage return
lf      equ     0ah             ; ASCII linefeed





cseg    segment para public 'CODE'

        org     100h


        assume  cs:cseg,ds:cseg,es:cseg,ss:cseg

print   proc    near










        mov     dx,offset


        mov     ah,9
        int     21h

        mov     ax,4c00h
        int     21h

print   endp







message db      cr,lf,'Hello!',cr,lf,'$'

cseg    ends








        end     print