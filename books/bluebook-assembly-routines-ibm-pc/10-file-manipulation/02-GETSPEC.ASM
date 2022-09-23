; Get a File Specifier

; Function: 
; This routine gets a file specifier from the unformatted
; parameter area at 80h of the Program Segment Prefix and transfers it to
; an ASCIIZ buffer. When you enter a transient command, the DOS
; automatically fills the unformatted parameter area with the tail of the
; command line.

; Input:
; Upon entry, the unformatted parameter area must contain a file
; specifier and DS:DX must point to a buffer in memory.

; Output:
; The buffer is filled with the file specification as an ASCIIZ string.

; Registers Used: 
; No registers are modified. DX is used for input.

; Segments Referenced:
; Upon entry the extra segment must contain the ASCIIZ string buffer.

; Routines Called:
; None.

; Special Notes:
; The double word variable DTA must point to the default
; DTA in the Program Segment Prefix. In particular, the second word of
; this variable should be loaded with the Program Segment Prefix when the
; user first gains control. This segment value is initially contained in DS.



; ROUTINE TO GET A FILE SPECIFIER
;
getspec proc    far
;
        push    ds              ; save registers
        push    es
        push    si
        push    di
        push    cx
;
; set up pointer to dta to get parameters
        lds     si,dta          ; point to dta for parameters
        mov     cl,[si]         ; get length of string
        mov     ch,0            ; make 16-bit
        inc     si              ; skip the length byte
; scan past the spaces
        mov     al,' '          ; skip spaces
;
getspec1:
        cmp     [si],al         ; check for space
        jne     getspec2        ; exit the loop if nonspace
        inc     si              ; otherwise point to next byte
        loop    getspec1        ; loop back for more
        jcxz    getspec3        ; no file specifier?
;
; move the rest into place
getspec2:
        mov     di,dx           ; index points to destination
        cld                     ; forward direction
        rep     movsb           ; make the transfer
        clc                     ; no error so no carry
        jmp     getspecexit     ; and return
;
getspec3:
        mov     ax,20           ; no file specified
        stc                     ; set carry for error
        jmp     getspecexit     ; and exit
;
getspecexit:
        pop     cx              ; save registers
        pop     di
        pop     si
        pop     es
        pop     ds
        ret
;
getspec endp