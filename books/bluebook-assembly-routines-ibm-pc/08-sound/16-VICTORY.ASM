; Play a Victory Bugle Call

; Function:
; This program plays a victory bugle call.

; Input:
; The "play" list is in the data segment included in the program.

; Output:
; To the speaker only.

; Registers Used:
; This is an EXE file which uses registers as needed.

; Segments Referenced:
; The relevant part of the data segment is included.

; Routines Called: 
; PLAY

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
; play list for "victory" bugle call
victory db      'T',60
        db      'N',55, 32,128
        db      'N',60, 32,128
        db      'N',64, 32,128
        db      'N',67, 48,228
        db      'N',67, 16,228
        db      'N',67, 32,228
        db      'N',64, 48,228
        db      'N',64, 16,228
        db      'N',64, 32,228
        db      'N',60, 32,128
        db      'N',64, 32,128
        db      'N',60, 32,128
        db      'N',55, 96,240
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
        lea     si,victory      ; point to the play list
        call    play            ; play the tune
;
        ret                     ; return to DOS
;
main    endp
;
codes   ends
        end     start