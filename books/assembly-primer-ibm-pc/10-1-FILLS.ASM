;FILLS--Fills monochrome video memory
;       with happy faces

;*********************************************
;define video memory as a segment

video   segment at 0b000h
        db      800h dup(?)

video   ends

;*********************************************
coder   segment             ;define code segment

;---------------------------------------------
fills   proc    far         ;main procedure

        assume  cs:coder    ;tell ASM where we are
        assume  ds:video    ;and where video is

;set up stack for return
        push    dx          ;save old DS contents
        sub     ax,ax       ;make a zero
        push    ax          ;save on stack

;put the video memory segment in DS
        mov     ax,video
        mov     ds,ax

;set up to insert happ face, normal attribute
        mov     ax,0701h    ;happy face
        mov     bx,0        ;start of buffer
        mov     cx,0f9fh    ;count

;fill the screen with happy faces
again:  mov     [bx],ax     ;insert char
        inc     bx          ;incr pointer
        inc     bx          ;  two bytes
        loop    again       ;again

        ret                 ;return to DOS

fills   endp                ;end of procedure
;---------------------------------------------
coder   ends                ;end of code segment
;*********************************************
        end                 ;end assembly