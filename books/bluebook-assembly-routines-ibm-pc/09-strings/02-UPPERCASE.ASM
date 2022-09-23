; Convert to Upper Case

; Function:
; This routine converts the characters in a string to upper case.

; Input:
; Upon entry DS:BX points to a string. The first two bytes in the
; string form a 16-bit integer which specifies its length. The remaining
; bytes contain the characters of the string.

; Output:
; Upon exit all alphabetical characters of the string are upper case.

; Registers Used: 
; No registers are modified.

; Segments Referenced:
; Upon entry the data segment must contain the string.

; Routines Called: 
; None



; ROUTINE TO CONVERT STRING TO UPPER CASE
;
uppercase       proc    far
;
        push    bx              ; save registers
        push    cx
        push    ax
;
; get the length
        mov     cx,[bx]         ; first two bytes contain the length
        inc     bx              ; point to beginning of text
        inc     bx
;
; loop through the bytes of the string
uppercase1:
        mov     al,[bx]         ; get the character
        cmp     al,'a'          ; below the lower case characters?
        jb      uppercase2      ; skip if so
        cmp     al,'z'          ; above the lower case characters?
        ja      uppercase2      ; skip if so
;
        and     al,5Fh          ; mask out bit number 5
;
uppercase2:
        mov     [bx],al         ; store the character
        inc     bx              ; point to next character
        loop    uppercase1
;
        pop     ax              ; restore registers
        pop     cx
        pop     bx
        ret
;
uppercase       endp