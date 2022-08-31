;GUN--Makes machine gun sound
;  fires fixed number of shots
;*********************************************

prognam segment ;define code segment

;---------------------------------------------
main    proc    far         ;main part of program

        assume  cs:program

        org     100h        ;start of program

start:          ;starting execution address

        mov     cx,20d      ;set number of shots
new_shot:
        push    cx          ;save count
        call    shoot       ;sound of shot
        mov     cx,4000h    ;set up silent delay
silent: loop    silent      ;silent delay
        pop     cx          ;get shots count back
        loop    new_shot    ;loop till shots done
        int     20h         ;return to DOS

main    endp    ;end of main part of program
;---------------------------------------------
;SUBROUTINE TO MAKE BRIEF NOISE

shoot   proc    near

        mov     dx,140h     ;initial value of wait
        mov     bx,20h      ;set count

        in      al,61h      ;get port 61h
        and     al,11111100b ;AND off bits #0, #1

sound:  xor     al,2        ;toggle bit #1 in AL
        out     61h,al      ;toggle to port 61

        add     dx,9248h    ;add random bit pattern
        mov     cl,3        ;set to rotate 3 bits
        ror     dx,cl       ;rotate it

        mov     cx,dx       ;put in CX
        and     cx,1ffh     ;mask off upper 7 bits
        or      cx,10       ;ensure not too short

wait:   loop    wait        ;wait


;made noise long enough?
        dec     bx          ;done enough?
        jnz     sound       ;jump if not yet

;turn off sound
        and     al,11111100b ;AND off bits 0, 1
        out     61h,al      ;turn off bits 0, 1

        ret                 ;return from subr

shoot   endp
;---------------------------------------------
prognam ends        ;end of code segment
;*********************************************

        end     start       ;end assembly