        name    hello
        page    55,132
        title   HELLO.EXE--print Hello on terminal

stdin   equ     0   
stdout  equ     1   
stderr  equ     2   

cr      equ     0dh 
lf      equ     0ah 


_TEXT   segment word public 'CODE'

        assume  cs:_TEXT,ds:_DATA,ss:STACK

print   proc    far

        mov     ax,_DATA
        mov     ds,ax

        mov     ah,40h
        mov     bx,stdout
        mov     cx,msg_len
        mov     dx,offset msg
        int     21h

        mov     ax,4c00h
        int     21h

print   endp

_TEXT   ends


_DATA   segment word public 'DATA'

msg     db      cr,lf
        db      'Hello World!',cr,lf

msg_len equ     $-msg

_DATA   ends


STACK   segment para stack 'STACK'

        db      128 dup (?)

STACK   ends

        end     print
