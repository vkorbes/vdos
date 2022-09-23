; Search for One String Within Another

; Function:
; This routine searches for a copy of a source string within a
; destination string.

; Input:
; Upon entry DS:BX points to a source string and ES:DX points
; to a destination string. Each string begins with a 16-bit integer which
; specifies its length.

; Output: 
; Upon exit AL contains a return flag (0 = not found,
; OFFh = found), and if the search was successful DX contains the location
; of the first byte of the match in the destination.

; Registers Used:
; Only AX and DX are modified. They are used for output.

; Segments Referenced:
; Upon entry the data segment must contain the
; source string and the extra segment must contain the destination string.

; Routines Called: 
; None

; Special Notes:
; None



; ROUTINE TO SEARCH FOR ONE STRING WITHIN ANOTHER
;
strsearch       proc    far
;
        push    si              ; save registers
        push    di
        push    cx
;
; get length of destination and point to first byte
        mov     si,dx           ; use source index
        lodsw                   ; get the length of destination
        mov     cx,ax           ; use the length as a count
        mov     dx,si           ; text begins here
;
strsearch1:
; point indices to beginning of source and destination
        mov     si,bx           ; load source index
        mov     di,dx           ; load destination index
;
; scan for match
        mov     al,[si+2]       ; get the first character
        cld                     ; forward direction
        repnz   scasb           ; scan for match
        jcxz    strsearch2      ; quit if found no match
;
; got a match of first characters - now check the entire string
        mov     dx,di           ; save current destination loc
        dec     di              ; beginning of word
        lodsw                   ; get length of source
        xchg    cx,ax           ; use source count and save dest count
        repz    cmpsb           ; compare the two strings
        jcxz    strsearch3      ; it's a match if no more source
;
; continue the scan
        xchg    cx,ax           ; use destination count
        jmp     strsearch1      ; back for more scanning of dest
;
; no match is possible
strsearch2:
        mov     al,0            ; unsuccessful outcome
        jmp     strsearchexit
;
; found a match
strsearch3:
        dec     dx              ; point to beginning of match
        mov     al,0FFh         ; successful match
        jmp     strsearchexit
;
strsearchexit:
        pop     cx              ; restore registers
        pop     di
        pop     si
        ret
;
strsearch       endp