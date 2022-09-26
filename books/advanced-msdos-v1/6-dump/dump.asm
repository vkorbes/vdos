        name    dump
        page    55,132
        title   'DUMP --- Display File Contents'











cr      equ     0dh
lf      equ     0ah
blank   equ     20h

command equ     80h

blksize equ     128

output_handle equ 1

error_handle equ 2


cseg    segment para public 'CODE'

        assume  cs:cseg,ds:data,es:data,ss:stack


dump    proc    far

        push    ds
        xor     ax,ax
        push    ax
        mov     ax,data
        mov     es,ax
        mov     ah,30h
        int     21h
        cmp     al,2
        jae     dump1
        mov     dx,offset msg3
        mov     ax,es
        mov     ds,ax
        mov     ah,9
        int     21h
        ret

dump:   call    get_filename

        mov     ax,es
        mov     ds,ax
        jnc     dump2
        mov     dx,offset msg2
        mov     cx,msg2_length
        jmp     dump9

dump2:  call    open_input
        jnc     dump3
        mov     dx,offset msg1
        mov     cx,msg1_length
        jmp     dump9

dump3:  call    read_block
        jnc     dump4
        mov     dx,offset msg4
        mov     msg4_length
        jmp     dump9


dump4:
        call    get_char
        jc      dump8
        inc     input_addr
        or      bx,bx
        jnz     dump5
        call    print_heading
dump5:  and     bx,0fh
        jnz     dump6
        push    ax
        mov     di,offset output
        mov     ax,input_addr
        call    conv_word
        pop     ax
dump6:

        mov     di,offset outputb
        add     di,bx
        mov     byte ptr [di],'.'
        cmp     al,blank
        jb      dump7
        cmp     al,7eh
        ja      dump7
        mov     [di],al
dump7:

        push    bx


        mov     di,offset outputa
        add     di,bx
        add     di,bx
        add     di,bx
        call    conv_byte
        pop     bx
        cmp     bx,0fh
        jne     dump4
        mov     dx,offset output
        mov     cx,output_length
        call    write_std
        jmp     dump4

dump8:
        call    close_input
        mov     ax,4c00h
        int     21h

dump9:

        call    write_error
        mov     ax,4c01h
        int     21h

dump    endp


get_filename proc near



        mov     si,offset command

        mov     di,offset input_name
        cld
        lodsb
        or      al,al
        jz      get_filename4
get_filename1:
        lodsb
        cmp     al,cr
        je      get_filename4
        cmp     al,20h
        jz      get_filename1
get_filename2:
        stosb

        lodsb
        cmp     al,cr
        je      get_filename3
        cmp     al,20h
        jne     get_filename2
get_filename3:
        clc
        ret
get_filename4:
        stc
        ret
get_filename endp

open_input proc near

        mov     dx,offset intput_name
        mov     al,0
        mov     ah,3dh
        int     21h
        mov     input_handle,ax
        ret
open_input endp

close_input proc near
        mov     bx,input_handle
        mov     ah,3eh
        int     21h
        ret
close_input endp

get_char proc   near


        mov     bx,input_ptr
        cmp     bx,blksize
        jne     get_char1

        mov     input_ptr,0
        call    read_block
        jnc     get_char
        ret

get_char1:
        mov     al,[input_buffer+bx]
        inc     input_ptr
        clc
        ret
get_char endp


read_block proc near


        mov     bx,input_handle
        mov     cx,blksize
        mov     dx,offset input_buffer
        mov     ah,3fh
        int     21h

        inc     input_block
        mov     input_ptr,0
        or      ax,ax

        jnz     read_block1
        stc
read_block1:
        ret
read_block  endp

write_std proc  near


        mov     bx,output_handle
        mov     ah,40h
        int     21h
        ret
write_std endp

write_error proc near


        mov     bx,error_handle
        mov     ah,40h
        int     21h
        ret
write_error endp

print_heading proc near
        push    ax
        push    bx
        mov     di,offset headinga
        mov     ax,input_block
        call    conv_word
        mov     dx,offset heading
        mov     cx,heading_length
        call    write_std
        pop     bx
        pop     ax
        ret
print_heading endp

conv_word proc near




        push    ax
        mov     al,ah
        call    conv_byte
        pop     ax
        call    conv_byte
        ret
conv_word endp

conv_byte proc  near




        sub     ah,ah
        mov     cl,16
        div     cl
        call    ascii
        stosb
        mov     al,ah
        call    ascii
        stosb
        ret
conv_byte endp

ascii   proc    near
        add     al,'0'
        cmp     al,'9'
        jle     ascii2
        add     al,'A'-'9'-1
ascii2: ret
ascii   endp

cseg    ends


data    segment para public 'DATA'

input_name      db      64 dup (0)

input_handle    dw      0

input_ptr       dw      0

input_addr      dw      -1
input_block     dw      0

output          db      'nnnn',blank,blank
outputa         db      16 dup ('00',blank)
                db      blank
outputb         db      '0123456789ABCDEF',cr,lf
output_length   equ     $-output

heading         db      cr,lf,'Record',blank
headinga        db      'nnnn',blank,blank,cr,lf
                db      7 dup (blank)
                db      '0  1  2  3  4  5  6  7  '
                db      '8  9  A  B  C  D  E  F',cr,lf
heading_length  equ     $-heading

input_buffer    db      blksize dup (?)

msg1            db      cr,lf
                db      'Cannot find input file.'
                db      cr,lf
msg1_length     equ     $-msg1

msg2            db      cr,lf
                db      'Missing file name.'
                db      cr,lf
msg2_length     equ     $-msg2

msg3            db      cr,lf
                db      'Requires DOS version 2 or greater.'
                db      cr,lf,'$'

msg4            db      cr,lf,'Empty file.',cr,lf
msg4_length     equ     $-msg4

data    ends


stack   segment para stack 'STACK'
        db      64 dup (?)
stack   ends

        end     dump