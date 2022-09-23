; ROUTINE TO SEARCH FOR A WORD IN AN ORDERED LIST OF WORDS
;
lexsearch       proc    far
;
        push    si              ; save registers
        push    di
        push    cx
;
; point to beginning of list and get its length
        mov     di,bp           ; beginning of list
        mov     cx,[di]         ; get length
        inc     di
        inc     di
;
; compare source word with words in the list
;
lexsearch1:
;
        mov     dx,di           ; save beginning of dest word
;
; forward direction
        cld                     ; forward direction
;
; point to beginning of source
        mov     si,bx           ; point to beginning of source
        inc     si
        inc     si
;
; compare source word with a word of the list
lexsearch2:
;
; check for end of list
        jcxz    lexsearch5      ; end of list - insert it
;
; set up carriage return as character for scanning
        mov     al,13           ; scan for carriage return
;
; check for end of source word
        cmp     [si],al         ; source byte = carriage return?
        je      lexsearch4      ; end of source word found
;
; check for end of destination word
        cmp     es:[di],al      ; dest byte = carriage return?
        je      lexsearch3      ; no match - go to next word
;
; compare character by character
        dec     cx
        cmpsb                   ; check for match
        je      lexsearch2      ; matched - check next character
        jb      lexsearch5      ; too high - this is the place
;
; scan for next carriage return
lexsearch3:
        repnz   scasb           ; scan until carriage return
        jmp     lexsearch1      ; next word
;
; end of source word was found
lexsearch4:
        cmp     [di],al         ; dest character = carriage return?
        je      lexsearch6      ; end of destination word?
;
; found a spot to insert the word
lexsearch5:
        mov     al,0FFh         ; success
        jmp     lexsearchexit
;
lexsearchexit:
        pop     cx              ; restore registers
        pop     di
        pop     si
        ret
;
lexsearch       endp