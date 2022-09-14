; read keys from keyboard

code    segment

        assume cs:code
        org 100h

start:
   mov      ah,00h
   int      16h
   cmp      al,41h
   je       exit
   mov      ah,0eh
   mov      bx,000fh
   int      10h
   jmp      start

    db      "LOUCURA"

exit:
   int      20h


code    ends

        end
