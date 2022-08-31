        page    55,132
        title   Ctrl-Break handler for Microsoft C programs
        name    break

























args    equ     4

cr      equ     0dh
lf      equ     0ah


_TEXT   segment byte public 'CODE'

        assume cs:_TEXT

        public  _capture,_release

        page











_capture proc   near

        push    bp
        mov     bp,sp
        push    ds
        push    di
        push    si

        mov     ax,word ptr [bp+args]
        mov     cs:flag,ax
        mov     cs:flag+2,ds


        mov     ax,3523h
        int     21h
        mov     cs:int23,bx
        mov     cs:int23+2,es

        mov     ax,351bh
        int     21h
        mov     cs:int1b,bx
        mov     cs:int1b+2,es

        push    cs
        pop     ds
        mov     dx,offset ctrlbrk
        mov     ax,02523h
        int     21h
        mov     ax,0251bh
        int     21h

        pop     si
        pop     di
        pop     ds
        pop     bp
        ret

_capture endp
        page












_release proc   near

        push    bp
        mov     bp,sp
        push    ds
        push    di
        push    si

        mov     dx,cs:int1b
        mov     ds,cs:int1b+2
        mov     ax,251bh
        int     21h

        mov     dx,cs:int23
        mov     ds,cs:int23+2
        mov     ax,2523h
        in      21h

        pop     si
        pop     di
        pop     ds
        pop     bp
        ret

_release endp

        page













ctrlbrk proc    far

        push    bx
        push    ds

        mov     bx,cs:flag
        mov     ds,cs:flag+2
        mov     word ptr ds:[bx],-1

        pop     ds
        pop     bx

        iret

ctrlbrk endp


flag    dw      0,0


int23   dw      0,0



int1b   dw      0,0



_TEXT   ends

        end