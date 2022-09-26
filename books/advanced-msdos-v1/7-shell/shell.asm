        name    shell
        page    55,132
        title   'SHELL.ASM -- simple MS-DOS shell'












stdin   equ     0
stdout  equ     1
stderr  equ     2

cr      equ     0dh
lf      equ     0ah
blank   equ     20h
esc     equ     01bh

cseg    segment para public 'CODE'

        assume  cs:cseg,ds:data,ss:stack

shell   proc    far
        mov     ax,data
        mov     ds,ax
        mov     ax,es:[002ch]
        mov     env_seg,ax

        mov     bx,100h
        mov     ah,4ah
        int     21h
        jnc     shell1
        mov     dx,offset msg1
        mov     cx,msg1_length
        jmp     shell4
shell1: call    get_comspec
        jnc     shell2
        mov     dx,offset msg3
        mov     cx,msg3_length
        jmp     shell4
shell2: mov     dx,offset shell3
        mov     ax,cs
        mov     ds,ax
        mov     ax,2523h
        int     21h
        mov     ax,data
        mov     ds,ax
        mov     es,ax
shell3:
        call    get_cmd
        call    intrinsic
        jnc     shell3
        call    intrinsic
        jmp     shell3
shell4:

        mov     bx,stderr
        mov     ah,40h
        int     21h
        mov     ax,4c01h
        int     21h
shell   endp


stk_seg dw      0
stk_ptr dw      0


intrinsic proc  near




        mov     si,offset commands
intr1:  cmp     byte ptr [si],0
        je      intr7
        mov     di,offset inp_buf
intr2:  cmp     byte ptr [di],blank
        jne     intr3
        inc     di
        jmp     intr2
intr3:  mov     al,[si]
        or      al,al
        jz      intr4
        cmp     al,[di]
        jnz     intr6
        inc     si
        inc     di
        jmp     intr3
intr4:  cmp     byte ptr [di],cr
        je      intr5
        cmp     byte ptr [di],blank
        jne     intr6
intr5:  call    word ptr [si+1]
        clc
        ret
intr6:  lodsb
        or      al,al
        jnz     intr6
        add     si,2
        jmp     intr1
intr7:  stc
ret
intrinsic endp


extrinsic proc  near


        mov     al,cr
        mov     cx,cmd_tail_length
        mov     di,offset cmd_tail+1
        cld
        repnz scasb
        mov     ax,di
        sub     ax,offset cmd_tail+2

        mov     cmd_tail,al
        mov     par_cmd,offset cmd_tail
        call    exec
        ret
extrinsic endp


get_cmd proc    near
        mov     dx,offset prompt
        mov     cx,prompt_length
        mov     bx,stdout
        mov     ah,40h
        int     21h
        mov     dx,offset inp_buf
        mov     cx,inp_buf_length
        mov     bx,stdin
        mov     ah,3fh
        int     21h
        mov     si,offset int_buf
        mov     cx,inp_buf_length
gcmd1:  cmp     byte ptr [si],'a'
        jb      gcmd2
        cmp     byte ptr [si],'z'
        ja      gcmd2
        sub     byte ptr [si],'a'-'A'
gcmd2:  inc     si
        loop    gcmd1
        ret
get_cmd endp


get_comspec proc near



        mov     si,offset com_var
        call    get_env

        jc      gcsp2

        mov     si,offset com_spec
gcsp1:  mov     al,es:[di]
        mov     [si],al
        inc     si
        inc     di
        or      al,al
        jnz     gcsp1

gcsp2:  ret
get_comspec endp


get_env proc    near





        mov     es,env_seg
        xor     di,di
genv1:  mov     bx,si
        cmp     byte ptr es:[di],0
        jne     genv2
        stc
        ret
genv2:  mov     al,[bx]
        or      al,al
        jz      genv3
        cmp     al,es:[di]
        jne     genv4
        inc     bx
        inc     di
        jmp     genv2
genv3:
        ret
genv4:  xor     al,al
        mov     cx,-1
        cld
        repnz   scasb
        jmp     genv1
get_env endp


exec    proc    near

        push    ds
        push    es
        mov     cs:stk_seg,ss
        mov     cs:stk_ptr,sp
        mov     dx,offset com_spec
        mov     bx,offset par_blk
        mov     ah,4bh
        mov     al,0
        int     21h
        mov     ss,cs:stk_seg
        mov     sp,cs:stk_ptr
        pop     es
        pop     ds
        jnc     exec1
        mov     dx,offset msg2
        mov     cx,msg2_length
        mov     bx,stderr
        mov     ah,40h
        int     21h
exec1:  ret
exec    endp


cls_cmd proc    near

        mov     dx,offset cls_str
        mov     cx,cls_str_length
        mov     bx,stdout
        mov     ah,40h
        int     21h
        ret
cls_cmd endp


dos_cmd proc    near

        mov     par_cmd,offset nultail
        call    exec
        ret
dos_cmd endp


exit_cmd proc   near

        mov     ax,4c00h
        int     21h
exit_cmd endp


cseg    ends


stack   segment para stack 'STACK'
        dw      64 dup (?)
stack   ends


data    segment para public 'DATA'

commands equ $




        db      'CLS',0
        dw      cls_cmd
        db      'DOS',0
        dw      dos_cmd
        db      'EXIT',0
        dw      exit_cmd
        db      0

com_var db      'COMSPEC=',0


com_spec db     80 dup (0)

nultail db      0,cr


cmd_tail db     0,' /C '


inp_buf db      80 dup (0)

inp_buf_length equ $-inp_buf
cmd_tail_length equ $-cmd_tail-1

prompt  db      cr,lf,'sh: '
prompt_length equ $-prompt

env_seg dw      0

msg1    db      cr,lf
        db      'Unable to de-allocate memory.'
        db      cr,lf
msg1_length equ $-msg1

msg2    db      cr,lf
        db      'EXEC of COMMAND.COM failed.'
        db      cr,lf
msg2_length equ $-msg2

msg3    db      cr,lf
        db      'No COMSPEC variable in Environment.'
        db      cr,lf
msg3_length equ $-msg3

cls_str db      esc,'[2J'
cls_str_length equ $-cls_str

par_blk equ     $
        dw      0
par_cmd dw      offset cmd_tail
        dw      seg cmd_tail
        dd      -1
        dd      -1

data    ends

        end     shell