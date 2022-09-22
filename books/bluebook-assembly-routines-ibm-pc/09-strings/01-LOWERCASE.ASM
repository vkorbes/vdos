; Convert to Lower Case

; Function:
; This routine converts the characters in a string to lower case.

; Input:
; Upon entry DS:BX points to a string. The first two bytes in the
; string form a 16-bit integer which specifies its length. The remaining
; bytes contain the characters of the string.

; Output:
; Upon exit all alphabetical characters of the string are lower case.

; Registers Used: No registers are modified.

; Segments Referenced:
; Upon entry the data segment must contain the string.

; Routines Called:
; None

; Special Notes:
; None



; ROUTINE TO CONVERT STRING TO LOWER CASE
;
lowercase       proc    far
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
lowercase1:
        mov     al,[bx]         ; get the character
        cmp     al,'A'          ; below the upper case characters?
        jb      lowercase2      ; skip if so
        cmp     al,'Z'          ; above the upper case characters?
        ja      lowercase2      ; skip if so
;
        or      al,20h          ; OR bit 5 into the byte
;
lowercase2:
        mov     [bx],al         ; store the character
        inc     bx              ; point to next character
        loop    lowercase1
;
        pop     ax              ; restore registers
        pop     cx
        pop     bx
        ret
;
lowercase       endp