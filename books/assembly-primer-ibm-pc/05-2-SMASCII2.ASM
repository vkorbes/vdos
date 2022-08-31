prognam segment             ; start of segment

        assume cs:prognam   ; assume what's in CS

        mov  cx,100h        ; put count in CX
        mov  dl,0           ; first ASCII character
next:
        mov  ah,2           ; Display Output funct
        int  21h            ; call DOS to print
        inc  dl             ; next ASCII character
        loop next           ; do again, unless done

        int 20h             ; return to DOS

prognam ends                ; end of segment

        end                 ; end of assembly