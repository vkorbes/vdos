; Play Opening of Strauss Horn Concerto

; Function:
; This program plays the opening bars of a French horn
; concerto by Richard Strauss (Concerto No. 1 in E flat).

; Input:
; The "play" list is in the data segment included in the program.

; Output:
; To the speaker only.

; Registers Used: 
; This is an EXE file which uses registers as needed.

; Segments Referenced:
; The relevant part of the data segment is included.

; Routines Called: PLAY

; Special Notes:
; None



; ---------------------- external reference
; EXTERNAL REFERENCES
        extrn   play:far
; ---------------------- stack segment
stacks  segment stack
        db      20 dup('stack   ')
stacks  ends
; ---------------------- data segment
datas   segment public
;
; play list for horn concerto
victory db      'T',28
        db      'N',58, 24,192
        db      'N',62,  8,192
;
        db      'N',65, 96,192
        db      'N',62, 24,192
        db      'N',67,  8,192
;
        db      'N',65, 32,192
        db      'N',62, 24,192
        db      'N',58,  8,192
        db      'N',53, 32,192
        db      'N',58, 24,192
        db      'N',62,  8,192

        db      'N',60, 32,192
        db      'N',58, 24,192
        db      'N',53,  8,192
        db      'N',50, 32,192
        db      'N',46, 24,192
        db      'N',55,  8,192

        db      'N',53, 64,192
        db      'N',41, 64,192
        db      'X'
;
datas   ends
; ---------------------- code segment
codes   segment
;
        assume  cs:codes,ss:stacks,ds:datas
;
main    proc    far
;
start:
        push    ds              ; set return address segment
        mov     ax,0            ;  and offset
        push    ax
;
        mov     ax,datas        ; get data segment
        mov     ds,ax           ; into DS
;
        lea     si,horn         ; point to the play list
        call    play            ; play the tune
;
        ret                     ; return to DOS
;
main    endp
;
codes   ends
        end     start