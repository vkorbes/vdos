;MEMSCAN--Scans entire megatybe of memory
;
;  Assigns a symbol to each group of 1024 bytes
;    symbol is "." if nothing there
;    symbol is "X" if something there
;
;  Output arranged:
;    8 groups/division,
;    8 divisions/line,
;    16 lines/screen
;
;    1024 * 8 * 8 * 16 = 1048576
;
pmess   equ     9h      ;print message function
display equ     2h      ;display output char fn
doscall equ     21h     ;DOS interrupt address
;
;*********************************************
;
;segment to define ES
;
x_seg   segment
x_byte  db      ?
x_seg   ends
;*********************************************
;
;variable storage area
;
var_area segment
;
lines    db     ?
div_line db     ?
gp_div   db     ?
header   db     '       0000    2000    4000    6000
                        8000    A000    C000    E000$'
colon    db     ': $'
footer   db     0ah,0dh,'X     X     X     X     X     X     X     X'
         db     0ah,0dh,'000   400   800   C00   1000  1400  1800  1C00$'
;
var_area ends
;*********************************************
;
memscan segment
;
;---------------------------------------------
main    proc    far
;
        assume  cs:memscan, ds:var_area
        assume  es:x_seg
;
;set up stack for return
start:
        push    ds          ;save DS
        sub     ax,ax       ;clear AX to 0
        push    ax          ;push 0
;
;
;set data segment to work area
        mov     ax,var_area
        mov     ds,ax
;
;initialization
        mov lines,16d       ;lines per screen = 16
        sub     ax,ax       ;set AX to 0
        mov     es,ax       ;set ES register to 0
;
;print header
        call    crlf        ;skip a line
        mov     dx,offset header ;addr of message
        mov     ah,pmess    ;print mess function
        int     doscall     ;call DOS
        call    crlf        ;skip a line
;
;start a new line
new_line:
;print contents of ES register at start of line
        mov     bx,es       ;print contents of ES
        call    binihex     ;  on screen in hex
;print colon and space
        mov     dx,offset colon
        mov     ah,pmess    ;print message funct
        int     doscall     ;call DOS
;
        mov gp_div,8d       ;divisions per line = 8
        mov     bx,0        ;set BX to zero
;
;start a new division
new_div:
        mov gp_div,8d       ;groups/division = 8
;
;start a new group
new_grp:
        mov     cx,128d     ;samples per group = 128d
;
;read two bytes and compare them
new_byte:
        mov     al,[bx + x_byte]
        mov     ah,[bx + x_byte + 2]
        and ax,7f7fh        ;mask off high bits
        cmp     al,ah       ;does 1st = 2nd ?
        je      nx_byte     ;yes, nothing here
;
;may be something, look at third byte
        mov     dl,[bx + x_byte + 5]
        and     dl,7fh      ;mask off high bit
        cmp     al,dl       ;does 1st = 3rd ?
        je      nx_byte     ;yes
        cmp     ah,dl       ;does 2nd = 3rd ?
        je      nx_byte     ;yes
;
;three bytes all different found,
;  so there's something in this group
        mov     dl,'X'      ;print "X"
        mov     ah,display  ;display function
        int     doscall     ;call DOS
;
;advance BX to next group
        and     bx,0fc00h   ;mask off lower 10 bits
        add     bx,1024d    ;add 1024d (400h)
        jmp     done_grp    ;done this group
;
;nothing found yet, get next byte
nx_byte:
        add     bx,8d       ;increment byte pointer
        dec     cx          ;done this group?
        jnz     new_byte    ;not yet
;done group, so print a period
        mov     dl,'.'      ;char in DL
        mov     ah,display  ;display function
        int     doscall     ;call DOS
;
;we've done one group (1024 bytes)
done_grp:
        dec     gp_div      ;done a division?
        jnz     new_grp     ;no, do next group
        mov     dl,' '      ;yes, print space
        mov     ah,display  ;display function
        int     doscall     ;call DOS
;
;we've done one division (8 groups)
done_div:
        dec     div_line    ;done 8 divisions?
        jnz     new_div     ;no, do next division
        call    crlf        ;yes, print cr & lf
        mov     ax,es       ;advance the ES
        add     ax,1000h    ;  to next segment
        mov     es,ax       ;  (add 65536d)
;
;we've done one line (8 segments)
done_line:
        dec     lines       ;done 16 lines?
        jnz     new_line    ;no, do next line
;
;print out values of X positions on bottom row
        mov     dx,offset footer
        mov     ah,pmess    ;print message function
        int     doscall     ;call DOS
        ret                 ;yes, return to dos
;
main    endp
;---------------------------------------------
;
crlf    proc    near

        mov     dl,0dh      ;carriage return
        mov     ah,display  ;display function
        int     doscall     ;call DOS
        mov     dl,0ah      ;linefeed
        mov     ah,display  ;display function
        int     doscall     ;call DOS
        ret
crlf    endp
;---------------------------------------------
;
binihex proc    near
;
;subroutine to convert binary number in BX
;  to hex and print out on console screen
;
        mov  ch,4       ;number of digits
rotate: mov  cl,4       ;set count to 4 bits
        rol  bx,cl      ;left digit to right
        mov  al,bl      ;move to AL (DL???)
        and  al,0fh     ;mask off left digit
        add  al,30h     ;convert hex to ASCII
        cmp  al,3ah     ;is it > 9?
        jl   printit    ;no, so 0 to 9 digit
        add  al,7h      ;yes, so A to F digit
printit:
        mov  dl,al      ;put ASCII char in DL
        mov  ah,display ;display output funct.
        int  doscall    ;call DOS
        dec  ch         ;done 4 digits?
        jnz  rotate     ;not yet, do another
        ret             ;done subroutine
;
binihex endp
;---------------------------------------------
;
memscan ends
;*********************************************
        end     start