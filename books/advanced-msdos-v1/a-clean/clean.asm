        name    clean
        page    55,132
        title   'CLEAN - Filter text file'


















tab     equ     09h
lf      equ     0ah
ff      equ     0ch
cr      equ     0dh
eof     equ     01ah
blank   equ     020h

tab_wid equ     8

stdin   equ     0000
stdout  equ     0001
stderr  equ     0002

cseg    segment para public 'CODE'

        assume  cs:cseg,ds:dseg,es:dseg,ss:sseg

clean   proc    far

        mov     ax,dseg
        mov     ds,ax
        mov     es,ax

        mov     ah,30h
        int     21h
        cmp     al,2
        jae     clean2
        mov     dx,offset msg1
        mov     ah,9
        int     21h
        mov     ah,0
        int     21h

clean2: call    getchar
        and     al,07fh
        cmp     al,blank
        jae     clean4
        cmp     al,eof
        je      clean9
        cmp     al,tab
        je      clean7
        cmp     al,cr
        je      clean3
        cmp     al,lf
        je      clean3
        cmp     al,ff
        jne     clean2

clean3: mov     column,0
        jmp     clean5

clean4: inc     column


clean5: call    putchar
        jnc     clean2

        mov     dx,offset msg2
        mov     cx,msg2_len

clean6: mov     bx,stderr
        mov     ah,40h
        int     21h
        mov     ax,4c01h
        int     21h

clean7: mov     ax,column
        cwd
        mov     cx,tab_wid
        idiv    cx
        sub     cx,dx
        add     column,cx

clean8: push    cx
        mov     al,blank
        call    putchar
        pop     cx
        loop    clean8
        jmp     clean2

clean9: call    putchar
        mov     ax,4c00h
        int     21h

clean   endp

getchar proc    near

        mov     bx,stdin
        mov     cx,1
        mov     dx,offset ibuff
        mov     ah,3fh
        int     21h
        or      ax,ax
        jz      getc1
        mov     al,ibuff
        ret
getc1:  mov     al,eof
        ret
getchar endp

putchar proc    near

        mov     obuff,al
        mov     bx,stdout
        mov     cx,1
        mov     dx,offset obuff
        mov     ah,40h
        int     21h
        cmp     ax,1
        jne     putc1
        clc
        ret
        ret
putc1:  stc
        ret
putchar endp

cseg    ends

dseg    segment para public 'DATA'

ibuff   db      0

obuff   db      0


column  dw      0

msg1    db      cr,lf
        db      'clean: need MS-DOS version 2 or greater.'





        db      cr,lf,'$'

msg2    db      cr,lf
        db      'clean: disk is full.


        db      cr,lf
msg2_len equ    $-msg2

dseg    ends

sseg    segment para stack 'STACK'

        dw      64 dup (?)



sseg    ends

        end     clean