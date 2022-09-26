        name    driver
        page    55,132
        title   'DRIVER --- installable driver template'









code    segment public 'CODE'

driver  proc    far

        assume  cs:code,ds:code,es:code

        org 0


Max_Cmd equ     16




cr      equ     0dh
lf      equ     0ah
eom     equ     '$'


        page



Header  dd      -1

        dw      8000h

















        dw  Strat

        dw  Intr

        db  'DRIVER  '










RH_Ptr  dd      ?
        page






Dispatch:
        dw      Init
        dw      Media_Chk      
        dw      Build_Bpb
        dw      IOCTL_Rd
        dw      Read
        dw      ND_Read
        dw      Inp_Stat
        dw      Inp_Flush
        dw      Write
        dw      Write_Vfy
        dw      Outp_Stat
        dw      Outp_Flush
        dw      IOCTL_Wrt
        dw      Dev_Open
        dw      Dev_Close
        dw      Rem_Media
        dw      Out_Busy
        page








    
Request strc



Rlength db      ?

Unit    db      ?

Command db      ?

Status  dw      ?






Reserve db      8 dup (?)







Media   db      ?

Address dd      ?

Count   dw      ?

Sector  dw      ?

Request ends
        page











Strat   proc    far

        mov     word ptr cs:[RH_Ptr],bx
        mov     word ptr cs:[RH_Ptr+2],es

        ret

Strat   endp

        page














Intr    proc    far

        push    ax
        push    bx
        push    cx
        push    dx
        push    ds
        push    es
        push    di
        push    si
        push    bp

        push    cs
        pop     ds

        les     di,[RH_Ptr]


        mov     bl,es:[di.Command]
        xor     bh,bh
        cmp     bx,Max_Cmd
        jle     Intr1
        mov     ax,8003h
        jmp     Intr2

Intr1:  shl     bx,1

        call    word ptr [bx+Dispatch]


        les     di,[RH_Ptr]

Intr2:  or      ax,0100h

        mov     es:[di.Status],ax

        pop     bp
        pop     si
        pop     di
        pop     es
        pop     ds
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret

        page











Media_Chk proc  near

        xor     ax,ax
        ret

Media_Chk endp


Build_Bpb proc  near

        xor     ax,ax
        ret

Build_Bpb endp


IOCTL_Rd proc   near

        xor     ax,ax
        ret

IOCTL_Rd endp


Read proc   near

        xor     ax,ax
        ret

Read endp


ND_Read proc    near

        xor     ax,ax
        ret

ND_Read endp


Inp_Stat proc   near

        xor     ax,ax
        ret

Inp_Stat endp


Inp_Flush proc  near

        xor     ax,ax
        ret

Inp_Flush endp


Write proc  near

        xor     ax,ax
        ret

Write endp


Write_Vfy proc  near

        xor     ax,ax
        ret

Write_Vfy endp


Outp_Stat proc  near

        xor     ax,ax
        ret

Outp_Stat endp


Outp_Flush proc near

        xor     ax,ax
        ret

Outp_Flush endp


IOCTL_Wrt proc  near

        xor     ax,ax
        ret

IOCTL_Wrt endp


Dev_Open proc   near

        xor     ax,ax
        ret

Dev_Open endp


Dev_Close proc  near

        xor     ax,ax
        ret

Dev_Close endp


Rem_Media proc  near

        xor     ax,ax
        ret

Rem_Media endp


Out_Busy proc   near

        xor     ax,ax
        ret

Out_Busy endp
        page

















Init    proc    near

        push    es
        push    di

        mov     ax,cs
        mov     bx,offset DHaddr
        call    hexasc

        mov     ah,9
        mov     dx,offset Ident
        int     21h

        pop     di
        pop     es


        mov     word ptr es:[di.Address],offset Init
        mov     word ptr es:[di.Address+2],cs

        xor     ax,ax
        ret

Init    endp


Ident   db      cr,lf,lf
        db      'Example Device Driver 1.0'



        db      cr,lf
        db      'Device Header at '


DHaddr  db      'XXXX:0000'

        db      cr,lf,lf,eom


Intr    endp

        page









hexasc  proc    near

        push    cx
        push    dx

        mov     dx,4

hexasc1:
        mov     cx,4
        rol     ax,cl
        mov     cx,ax
        and     cx,0fh
        add     cx,'0'
        cmp     cx,'9'
        jbe     hexasc2

        add     cx,'A'-'9'-1

hexasc2:
        mov     [bx],cl
        inc     bx

        dec     dx
        jnz     hexasc1

        pop     dx
        pop     cx
        ret

hexasc  endp


Driver  endp

code    ends

        end