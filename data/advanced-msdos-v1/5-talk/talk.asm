        name    talk
        page    55,132
        .lfcond
        title   'TALK --- IBM PC terminal emulator'















cr      equ     0dh
lf      equ     0ah
bsp     equ     08h
esc     equ     1bh

dattr   equ     07h


echo    equ     0

comm_port equ   0

pic_mask  equ   21h
pic_eoi   equ   20h

        if      comm_port
comm_data equ   02f8h
comm_ier  equ   02f9h
comm_mcr  equ   02fch
comm_stat equ   02fdh
com_int   equ   0bh
int_mask  equ   08h
        else
comm_data equ   03f8h
comm_ier  equ   03f9h
comm_mcr  equ   03fch
comm_stat equ   03fdh
com_int   equ   0ch
int_mask  equ   10h  
        endif
        page

cseg    segment para public 'CODE'

        org     100h

        assume  cs:cseg,ds:cseg,es:cseg,ss:cseg

talk    proc    far




        mov     ah,15
        int     10h
        dec     ah
        mov     columns,ah
        cmp     al,7
        je      talk2
        cmp     al,3
        jbe     talk2
        mov     dx,offset msg1
        jmp     talk6

talk2:
        mov     bh,dattr
        call    cls

        call    asc_enb


talk3:  call    pc_stat

        jz      talk4
        call    pc_in
        cmp     al,0
        jne     talk32
        call    pc_in

        jmp     talk5

talk32:
        if      echo
        push    ax
        call    pc_out
        pop     ax
        endif
        call    com_out

talk4:  call    com_stat

        jz      talk3
        call    com_in

        cmp     al,20h
        jae     talk45
        call    ctrl_code
        jmp     talk3

talk45:
        call    pc_out
        jmp     talk4

talk5:

        mov     bh,07h
        call    cls
        mov     dx,offset msg2

talk6:  push    dx
        call    asc_dsb
        pop     dx
        mov     ah,9
        int     21h
        mov     ax,4c00h
        int     21h

talk    endp


com_stat proc   near


        push    dx
        mov     dx,asc_in
        cmp     dx,asc_out
        pop     dx
        ret
com_stat endp


com_in  proc    near
        push    bx
com_in1:
        mov     bx,asc_out
        cmp     bx,asc_in
        je      com_in1
        mov     al,[bx+asc_buf]
        inc     bx
        cmp     bx,asc_buf_len
        jne     com_in2
        xor     bx,bx
com_in2:
        mov     asc_out,bx
        pop     bx
        ret
com_in  endp


com_out proc    near
        push    dx
        push    ax
        mov     dx,comm_stat
com_out1:
        in      al,dx
        and     al,20h
        jz      com_out1
        pop     ax
        mov     dx,comm_data
        out     dx,al
        pop     dx
        ret
com_out endp


pc_stat proc    near




        mov     al,in_flag
        or      al,al
        jnz     pc_stat1
        mov     ah,6
        mov     dl,0ffh
        int     21h
        jz      pc_stat1


        mov     in_char,al
        mov     in_flag,0ffh
pc_stat1:
        ret
pc_stat endp


pc_in   proc    near


        mov     al,in_flag
        or      al,al
        jnz     pn_in1
        call    pc_stat
        jmp     pc_in
pc_in1: mov     in_flag,0
        mov     al,in_char
        ret
pc_in   endp


pc_out  proc    near

        mov     ah,0eh
        push    bx
        xor     bx,bx
        int     10h
        pop     bx
        ret
pc_out  endp


cls     proc    near


        mov     dl,columns
        mov     dh,24

        mov     cx,0

        mov     ax,600h


        int     10h
        call    home
        ret
cls     endp


clreol  proc    near


        call    getxy
        mov     cx,dx

        mov     dl,columns

        mov     ax,600h


        int     10h
        ret
clreol  endp


home    proc    near
        mov     dx,0
        call    gotoxy
        ret
home    endp


gotoxy  proc    near

        push    bx
        push    ax
        mov     bh,0
        mov     ah,2
        int     10h
        pop     ax
        pop     bx
        ret
gotoxy  endp


getxy   proc    near

        push    ax
        push    bx
        push    cx
        mov     ah,3
        mov     bh,0
        int     10h
        pop     cx
        pop     bx
        pop     ax
        ret
getxy   endp


ctrl_code proc  near

        cmp     al,cr
        je      ctrl8
        cmp     al,lf
        je      ctrl8
        cmp     al,bsp
        je      ctrl8

        cmp     al,26
        jne     ctrl7
        mov     bh,dattr
        call    cls
        ret

ctrl7:
        cmp     al,esc
        jne     ctrl9
        call    esc_seq
        ret

ctrl8:  call    pc_out

ctrl9:  ret

ctrl_code endp


esc_seq proc    near

        call    com_in
        cmp     al,84
        jne     esc_seq1
        mov     bh_dattr
        call    clreol
        ret
esc_seq1:
        cmp     al,61
        jne     esc_seq2
        call    com_in
        sub     al,33
        mov     dh,al
        call    com_in
        sub     al,33
        mov     dl,al
        call    gotoxy
esc_seq2:
        ret
esc_seq endp


asc_enb proc    near

        mov     ah,35h
        mov     al,com_int
        int     21h
        mov     intc_seg,es
        mov     intc_offs,bx

        mov     dx,offset asc_int
        mov     ah,25h
        mov     al,com_int
        int     21h

        mov     dx,comm_mcr
        mov     al,0bh
        out     dx,al

        mov     dx,comm_ier
        mov     al,1
        out     dx,al

        in      al,pic_mask
        and     al,not int_mask
        out     pic_mask,al

        ret

asc_enb endp

asc_dsb proc    near



        in      al,pic_mask
        or      al,int_mask
        out     pic_mask,al

        push    ds
        mov     dx,intc_offs
        mov     ds,intc_seg
        mov     ah,25h
        mov     al,com_int
        int     21h
        pop     ds
        ret
asc_dsb endp


asc_int proc    far


        sti
        push    ax
        push    bx
        push    dx
        push    ds
        mov     ax,cs
        mov     ds,ax
        mov     dx,comm_data
        in      al,dx
        cli

        mov     bx,asc_in
        mov     [asc_buf+bx],al
        inc     bx
        cmp     bx,asc_buf_len
        jne     asc_int1
        xor     bx,bx
asc_int1:
        mov     asc_in,bx
        sti
        mov     al,20h
        out     pic_eoi,al
        pop     ds
        pop     dx
        pop     bx
        pop     ax
        iret
asc_int endp


in_char         db      0
in_flag         db      0

columns         db      0


msg1            db      cr,lf,'Display must be text mode.'
                db      cr,lf,'$'

msg2            db      cr,lf,'Exit from terminal emulator.'
                db      cr,lf,'$'

intc_offs       dw      0
intc_seg        dw      0

asc_in          dw      0
asc_out         dw      0

asc_buf_len     equ     16384

asc_buf         equ     this byte

cseg    ends

        end     talk