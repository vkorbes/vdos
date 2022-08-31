prognam segment

        assume cs:prognam

        mov dl,1
        mov ah,2
        int 21h
        int 20h

prognam ends

        end