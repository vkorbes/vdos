;SEARCH--Searches one string for another
;  User types in keyword, then sentence
;  Program decides if sentence ontains word
;  Prints out conclusion

print_m equ 9h  ;print string function
buff_in equ 0ah ;buffered kbd input function
doscall equ 21h ;DOS interrupt number

;*********************************************

st_seg  segment stack   ;define stack segment
        db      20 dup  ('stack   ')

st_seg ends

;*********************************************

datarea segment         ;define data segment

;buffer to hold sentence
sen_max     db  127d         ;max chars in sentence
sen_real    db  ?            ;actual chars in sent.
sentence    db  127d dup (?) ;space for 127 chars

;buffer to hold keyword
key_max     db  20d         ;max chars in keyword
key_real    db  ?           ;actual chars in keyword
keyword     db  20d dup (?) ;space for 20 chars

mess1       db  0dh,0ah,'Enter Keyword: $'

mess2       db  0dh,0ah,'Enter Sentence: $'

mess3       db  0dh,0ah,'No match.$'

mess4       db  0dh,0ah,'Match!!!$'

datarea ends
;*********************************************

prognam segment         ;define code segment

;---------------------------------------------

main    proc    far     ;main part of program

        assume  cs:program,ds:datarea
        assume  es:datarea

start:          ;starting execution address

;set up stack for return
        push    ds          ;save old data segment
        sub     ax,ax       ;put zero in AX
        push    ax          ;save it on stack

;set DS register to current data segment
        mov     ax,datarea  ;datarea segment addr
        mov     ds,ax       ;  into DS register

;set ES register to current extra segment
        mov     ax,datarea  ;datarea segment addr
        mov     es,ax       ;  into ES register

;GET KEYWORD AND PUT IN BUFFER
new_key:

;print "enter keyboard" message
        mov     dx,offset key_max ;addr of buffer

        mov     ah,buff_in  ;buffered kbd input
        int     doscall     ;call DOS

;GET SENTENCE AND PUT IN BUFFER
new_sent:

;print "enter sentence" message
        mov     dx,offset mess2 ;addr in DX
        mov     ah,print_m  ;print string function
        int     doscall     ;call DOS

;get sentence and put in buffer 
        mov     dx,offset sen_max ;addr of buffer

        mov     ah,buff_in  ;buffered keybd input
        int     doscall     ;call DOS

;SEARCH FOR KEYWORD IN SENTENCE

;SI register holds pointer to keyword
;DI register holds pointer to sentence
;BX register holds pointer to 
;       current starting place in sentence
;DX register holds count of chars in sentence
;       less chars in keyword + 1
;CX register holds count of chars in word

        cld     ;set direction flag to forward

;calculate length of sentence less
;   length of keyword, put in DX
        mov     al,sen_real ;length of sentence
        sub     al,key_real ;less length of word
        jl      no_match    ;word longer than s.
        cbw                 ;change byte to word
        mov     dx,as       ;put in DX
        inc     dx          ; + 1

;set BX to first character in sentence
        mov     bx,offset sentence

compare:

;set DI to BX--this is place in sentence
;  where comparison will begin
        mov     di,bx

;set SI to start of keyword
        mov     si,offset keyword

;set CX to number of characters in keyword
        mov     al,key_real ;get count
        cbw                 ;change byte to word
        mov     cx,ax       ;put in CX

;compare keyword to this part of sentence
        repe    cmpsb       ;compare characters
                            ;repeat until CX = 0
                            ;or nonmatch is found
        jz      match       ;match found

;no match found here.  Advance BX to next
;  character in sentence, check if done
        inc     bx          ;advance pointer
        dex     dx          ;done?
        jz      no_match    ;yes, no match
        jmp     compare     ;no, try again

;print "match" message
match:
        mov     dx,offset mess4 ;addr in DX
        mov     ah,print_m  ;print string function
        int     doscall     ;call DOS
        jmp     new_sent    ;get another sentence

;print "no match" message
no_match:
        mov     dx,offset messa3; addr in DX
        mov     ah,print_m  ;print string function
        int     doscall     ;call DOS
        jmp     new_sent    ;get another sentence

        ret                 ;return to DOS

main    endp    ;end of main part of program
;---------------------------------------------
prognam ends        ;end of code segment
;*********************************************

        end     start       ;end assembly