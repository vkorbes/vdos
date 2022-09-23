; Filter to Count Words and Characters in a File

; Function:
; This routine counts the words and characters in a file. It can
; be used as a filter.

; Input: 
; Input is from the standard input device.

; Output:
; The output is sent to the standard output device.

; Registers Used:
; Registers are used as needed. This is the main program
; of an EXE command file.

; Segments Referenced:
; Upon entry the segments must be as specified for
; entry to EXE files.

; Routines Called: 
; STDINNE, STDOUT

; Special Notes:
; None



;
lf              equ     10
cr              equ     13
;
controlz        equ     1Ah     ; control Z
;
        extrn   stdinne:far,stdout:far,stdcrlf:far
        extrn   stdmessout:far
        extrn   dec16out:far
;
;**********************************************************
datas   segment public
;
; VARIABLES FOR COUNTING
;
charcount       dw      0
wordcount       dw      0
state           db      0
;
; MESSAGES
;
charmess        db      'characters:  ',0
wordmess        db      'words:       ',0
;
datas   ends
;**********************************************************
stacks  segment stack
        db      20 dup('stack   ')
stacks  ends
;**********************************************************
codes   segment
;
        assume  cs:codes,ds:datas
;
; LOCAL SUBROUTINE TO CHECK FOR ALPHANUMERICS
;
; Input: Upon entry ASCII code in AL
; Output: Upon exit CY = not alphanumeric
;                   NC = alphanumeric
;
alphanum        proc    near
;
        push    ax              ; save registers
;
        and     al,7Fh          ; strip off bit 7
        cmp     al,'1'          ; below '1'?
        jb      alphanum1       ; not alphanumeric
;
        cmp     al,'9'          ; from '1' to '9'?
        jbe     alphanum2       ; yes it's ok
;
        cmp     al,'A'          ; below 'A'?
        jbe     alphanum2       ; not alphanumeric
;
        cmp     al,'Z'          ; from 'A' to 'Z'?
        jbe     alphanum2       ; yes it's ok
;
        cmp     al,'a'          ; below 'a'?
        jbe     alphanum2       ; not alphanumeric
;
        cmp     al,'z'          ; from 'a' to 'z'?
        jbe     alphanum2       ; yes it's ok
;
        jmp     alphanum1       ; above 'z' is not alphanumeric
;
alphanum1:
        stc                     ; not alphanumeric
        jmp     alphanumexit
alphanum2:
        clc                     ; yes it's alphanumeric
        jmp     alphanumexit
;
alphanumexit:
        pop     ax              ; restore registers
        ret
;
alphanum        endp
;
;
; ROUTINE TO COUNT WORDS AND CHARACTERS IN A FILE
;
count   proc    far
;
        push    ds              ; save for proper return
        mov     ax,0            ; points to beginning of segment
        push    ax              ; for the offset
;
        mov     ax,datas        ; new data segment
        mov     ds,ax           ; put in DS
        mov     es,ax           ; and in ES
;
; initialize the counts and state
        mov     charcount,0     ; set character count to zero
        mov     wordcount,0     ; set word count to zero
        mov     state,0         ; and alphanumeric state too
;
; main loop
count1:
;
; get the next character
        call    stdinne         ; get the character without echo
        inc     charcount       ; count the character
;
; check for end of file
        cmp     al,controlz     ; end of file?
        jne     count2          ; skip if not
        jmp     countexit       ; exit if control Z is found
;
; check for alphanumeric
count2:
        call    alphanum        ; check for alphanumeric
        jc      count4          ; not alphanumeric
;
; current character is alphanumeric
count3:
        mov     al,1            ; current state is alphanumeric
        xchg    state,al        ; update state and get new state
        cmp     al,0            ; state change?
        jne     count5          ; skip if not
        inc     wordcount       ; count it if so
        jmp     count5
;
; current character is nonalphanumeric
count4:
        mov     state,0         ;current state is nonalphanumeric
;
count5:
        jmp     count1          ; loop back for next byte
;
countexit:
;
; report number of characters
        lea     si,charmess
        call    stdmessout
        mov     dx,charcount
        call    dec16out
        call    stdcrlf
;
; report number of words
        lea     si,wordmess
        call    stdmessout
        mov     dx,wordcount
        call    dec16out
        call    stdcrlf
;
; return
        ret
;
count   endp
codes   ends                    ; end of code segment
        end     count