;WINDOW--Demonstrates video window function
;  Uses ROM routines

;keyboard writes into a window 20 chars wide
;  and 9 chars high in middle of screen

;*********************************************
prognam segment             ;define code segment

        assume  cs:prognam

;clear screen, using scroll up function
        mov     ah,6        ;scroll up function
        mov     al,0        ;code to blank screen
        mov     ch,0        ;upper left row
        mov     cl,0        ;lower left column
        mov     dh,24       ;lower right row
        mov     dl,79       ;lower right column
        mov     bh,7        ;blank line attribute
        int     10h         ;video ROM call

;position cursor at bottom of window
pos_curse:

        mov     ah,2        ;position cursor funct
        mov     dh,16       ;starting row
        mov     dl,30       ;starting column
        mov     bh,0        ;current page
        int     10h         ;video ROM call

;get characters from keyboard

        mov     cx,20d  ;set count to 20

get_char:
        mov     ah,1        ;kbd input function
        int     21h         ;call DOS
        cmp     al,3        ;if char is ctrl-C
        jz      exit        ;  then exit
        loop    get_char

;scroll up
        mov     ah,6        ;scroll up function
        mov     al,1        ;number of lines
        mov     ch,8        ;upper left row
        mov     cl,30       ;upper left column
        mov     dh,16       ;lower right row
        mov     dl,50       ;lower right column
        mov     bh,7        ;normal attribute
        int     10h         ;video ROM call

        jmp     pos_curse   ;go reset cursor

exit:   int     20h

prognam ends    ;end of code segment
;*********************************************

        end     ;end assembly