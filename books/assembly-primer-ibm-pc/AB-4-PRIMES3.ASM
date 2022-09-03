;PRIMES3--Finds all prime numbers to 16381
;            using sieve of Eratosthenes
;            prints out total number

max     equ     16381d  ;highest number
display equ     2h      ;display char function
print_m equ     9h      ;print message function
doscall equ     21h     ;DOS interrupt number

;*********************************************

datarea segment         ;define data segment

numbers db  max dup (?) ;buffer for integers
mess1   db  'calculating. . .$'
mess2   db  '   $'      ;three spaces

datarea ends
;*********************************************

pro_nam segment         ;define code segment

;---------------------------------------------

main    proc    far     ;main part of program

        assume  cs:pro_nam,ds:datarea

start:          ;starting execution address

;set up stack for return
        push    ds          ;save DS on stack
        sub     ax,ax       ;set AX to zero
        push    ax          ;put on stack

;set DS to data segment
        mov     ax,datarea
        mov     ds,ax

;PRINT INITIAL MESSAGE
        mov     dx,offset mess1 ;load address
        mov     ah,print_m  ;print message function
        int     doscall     ;call DOS

;SET COUNT OF PRIMES TO ZERO (CX REGISTER)
        mov     cx,0        ;set CX to 0

;FILL ODD NUMBERS IN ARRAY WITH ZERO

        mov     bx,3        ;starts at 3
fill_0:
        mov     [numbers+bx],0  ;insert 0
        inc     bx          ;skip to next
        inc     bx          ;  odd number
        cmp     bx,max      ;done yet?
        jle     fill_0      ;not yet

;FIND PRIMES, CROSS OUT ALL THE NONPRIMES

        mov     bx,3        ;start with 3

;has this number been flagged as a nonprime?
search:
        mov     al,[numbers+bx] ;number into AL
        cmp     al,1        ;is it market with 1 ?
        je      go_next     ;yes, so it's nonprime

;no, so it's a prime

;the semicolon can be removed from the
;following line to print ou the primes
;       call    binidec     ;print the prime
        inc     cx          ;count the prime

;cross out all the numbers that are multiples
;   of this prime, by marking them "1"
        mov     si,bx       ;j=1
cross_out:
        add     si,bx       ;j=j+1
        cmp     si,max      ;gone too far yet?
        jg      go_next     ;yes
        mov     [numbers+si],1 ;cross it out
        jmp     cross_out   ;do next one

;have we looked at all the numbers?
go_next:
        inc     bx          ;skip to next
        inc     bx          ;  odd number
        cmp     bx,max      ;are we done?
        jle     search      ;not yet

;PRINT OUT TOTAL NUMBER OF PRIMES AND RETURN
        mov     bx,cx       ;put count in BX
        call    binidec     ;print it

        ret         ;return from program to DOS

main    endp    ;end of main part of program

;---------------------------------------------
binidec proc    near

;SUBROUTINE TO CONVERT BINARY NUMBER IN BX
;  TO DECIMAL ON CONSOLE SCREEN

        push    bx          ;save BX
        push    cx          ;save CX

;print three spaces
        mov     dx,offset mess2 ;spaces message
        mov     ah,print_m  ;print message func
        int     doscall     ;call DOS

;divide by successive powers of 10d
        mov     cx,10000d   ;divide by 10000
        call    dec_div
        mov     cx,1000d    ;divide by 1000
        call    dec_div
        mov     cx,100d     ;divide by 100
        call    dec_div
        mov     cx,10d      ;divide by 10
        call    dec_div
        mov     cx,1d       ;divide by 1
        call    dec_div

        pop     cx          ;restore CX
        pop     bx          ;restore BX
    
        ret                 ;return from binidec
;- - - - - - - - - - - - - - - - - - - - - - -
;
dec_div proc    near
;
;sub-subroutine to divide number in BX by
;  number in CX, print quotient on screen

        mov     ax,bx       ;put number in AX
        cwd     ;ax into ax and dx
        div     cx          ;divide by CX
        mov     bx,dx       ;remainder into BX
        mov     dl,al       ;quotient into DL

;print the contents of DL on screen
        add     dl,30h      ;convert to ASCII
        mov     ah,display  ;display function
        int     doscall     ;call DOS
        ret                 ;return from dev_div

dev_div endp
;- - - - - - - - - - - - - - - - - - - - - - -

binidec endp
;---------------------------------------------
pro_nam ends        ;end of code segment
;*********************************************

        end     start       ;end assembly