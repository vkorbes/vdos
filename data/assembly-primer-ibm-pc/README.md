# Assembly Primer for the IBM PC & XT

Requirements:
  - PC-DOS 1.00 or 1.10 acceptable, 2.00 preferable.
  - Standard IBM MACRO-Assembler.
    - [IBM Macro Assembler](https://winworldpc.com/product/ibm-macro-assembler/100)
    - [Microsoft Macro Assembler](https://winworldpc.com/product/macro-assembler/1x)
  - EXE2BIN, LINK, DEBUG, CREF.

Companion books:
  - IBM Personal Computer Technical Reference (manual)
  - IBM Personal Computer Disk Operating System (manual)
  - IBM Personal Computer MACRO Assembler (manual)

It mentions an Epson MX-80 or FX-80 printer.

> The 8086 has a full 16-bit architecture. The 8088 too, except that it talk to the outside world via 8-bit buses.


## DEBUG.COM

### Dump:

```
-d100
0731:0100 C3 00 00 00 00 00 00 00-00 00 00 00 00 00 00 00 ................
0731:0110 00 00 00 00 00 00 00 00-00 00 00 00 00 00 00 00 ................
0731:0120 00 00 00 00 00 00 00 00-00 00 00 00 00 00 00 00 ................
```

```
-d c000:0010
C000:0010 24 12 FF FF 00 00 00 00-60 00 00 00 00 20 49 42 $.......`.... IB
C000:0020 4D 20 43 4F 4D 50 41 54-49 42 4C 45 20 4D 41 54 M COMPATIBLE MAT
C000:0030 52 4F 58 2F 4D 47 41 2D-47 31 30 30 20 56 47 41 ROX/MGA-G100 VGA
```

### Fill:

```
-f 100 12f 'BUFFER'
-d 100 12f
xxxx:0100 42 55 46 46 45 52 42 55-46 46 45 52 42 55 46 46 BUFFERBUFFERBUFF
xxxx:0110 45 52 42 55 46 46 45 52-42 55 46 46 45 52 42 55 ERBUFFERBUFFERBU
xxxx:0120 46 46 45 52 42 55 46 46-45 52 42 55 46 46 45 52 FFERBUFFERBUFFER
```

### Enter:

```
-e100
-04B5:0100  61._
```

Program wanted:
```
B2
1
B4
2
CD
21
CD
20
```

On DEBUG.COM:
```
-e100
-04B5:0100  61.b2    61.1    61.b4   61.2    61.cd   61.21   61.cd   61.20
```

In mnemonics:

```
mov dl,1
mov ah,2
int 21
int 20
```

### Assemble:

```
-a100
08F1:100-
```

```
08F1:0100 mov dl,1
08F1:0102 _
```

Enter program in mnemonics above.

### Go:

```
-g
☺
Program terminated normally (0000)
-
```

"Breakpoint:"
```
-g 11b
```

### Unassemble:

```
-u
0731:0100 B201          MOV     DL,01
0731:0102 B402          MOV     AH,02
0731:0104 CD21          INT     21
0731:0105 CD20          INT     20
```

Further reading: [DOS DEBUG Commands](https://montcs.bloomu.edu/Information/LowLevel/DOS-Debug.html)

### Registers:

```
-r
AX=0000 BX=0000 CS=0000 DX=0000 SP=FFFE BP=0000 SI=0000 DI=0000
DS=0731 ES=0731 SS=0731 CS=0731 IP=0100 NV UP EI NG NZ NA PE NC
0731:0100 C3                RET
-rax
AX 0000 :1234
-rax
AX 1234 :_
````

Flags:
```
-rf
```

```
Flag Name:                      Set:    Clear:
Overflow (yes/no)               OV      NV
Direction (decrement/increment) DN      UP
Interrupt (enable/disable)      EI      DI
Sign (negative/positive)        NG      PL
Zero (yes/no)                   ZR      NZ
Auxilliary Carry (yes/no)       AC      NA
Parity (even/odd)               PE      PO
Carry (yes/no)                  CY      NC
```

### Saving to disk:

```
-nascii.com
-rbx
BX 0000
:
-rcx
CX 0000
:a
-w
Writing 000A bytes
```

## 3 - What Is Assembly Language?

> The AX register has special circuitry that makes it more suitable for doing arithmetic and logical operations than the other registers. The BX register can be used to point to memory addresses in a way that other registers can't, and the CX register is often used for counting.

### ASCII Display Program (ascii.com)

```
MOV     DL,00
MOV     AH,02
INT     21
INC     DL
JMP     102
```

(Requires reset. Suggestion: Replace JMP with JNZ, add INT 20.)

### Smarter ASCII Program (smascii.com)

```
MOV     CX,100
MOV     DL,0
MOV     AH,2
INT     21
INC     DL
LOOP    105
INT     20
```

### The SOUND Program

```
IN      AL,61
AND     AL,FC
XOR     AL,02
OUT     61,AL
MOV     CX,0140
LOOP    010B
JMP     0104
```

## 4 - Inside DOS

### Keyboard Input

```
MOV AH,01
INT 21
INT 20
```

### Print String

```
MOV DX,109
MOV AH,9
INT 21
INT 20
DB  'Good morning!$'
```

### Buffered Keyboard Input

```
MOV DX,0109
MOV AH,0A
INT 21
INT 20
DB  20
```

### The Mirror Program

```
MOV DX,0116
MOV AH,0A
INT 21
MOV DL,0A
MOV AH,02
INT 21
MOV DX,0118
MOV AH,09
INT 21
INT 20
DB  30
```

Test text must end with '$' character.

### Printer Output

INT 05 will break DOSBox, and do nothing on QEMU. Use INT 02 to print to screen instead.

```
MOV DL,[0122]
MOV AH,05
INT 21
MOV DL,[0123]
MOV AH,05
INT 21
MOV DL,[0124]
MOV AH,05
INT 21
MOV DL,[0125]
MOV AH,05
INT 21
INT 20
DB  'hi',0D,0A
```

```
MOV     CX,31
MOV     BX,111
MOV     DL,[BX]
MOV     AH,5
INT     21
INC     BX
LOOP    106
INT     20
DB      'She is most fair, though she be marble-hearted.',0D,0A
```

'Sending Control Codes to Printer' skipped as there's no printer and they'll be covered on the VGA chapter later.

## 5 - Introduction to the IBM MACRO Assembler

HAPPY2.ASM:

```
prognam segment

        assume cs:prognam

        mov dl,1
        mov ah,2
        int 21h
        int 20h

prognam ends

        end
```

SMASCII2.ASM:

```
prognam segment             ; start of segment

        assume cs:prognam   ; assume what's in CS

        mov  cx,100h        ; put count in CX
        mov  dl,0           ; first ASCII character
next:
        mov  ah,2           ; Display Output funct
        int  21h            ; call DOS to print
        inc  dl             ; next ASCII character
        loop next           ; do again, unless done

        int 20h             ; return to DOS

prognam ends                ; end of segment

        end                 ; end of assembly
```

Go to page 136 for LST introduction.

COMASM.BAT:

```
asm %1 %1 nul nul
link %1 @autolink
erase %1.bak
erase %1.obj
exe2bin %1 %1.com
erase %1.exe
```

AUTOLINK file needs 4 carriage returns.

## 6 - Using the IBM MACRO Assembler

BINIHEX.ASM

```
prognam segment         ; start of segment

        assume cs:prognam

        mov  ch,4       ; number of digits
rotate: mov  cl,4       ; set count to 4 bits
        rol  bx,cl      ; left digit to right
        mov  al,bl      ; move to AL
        and  al,0fh     ; mask off left digit
        add  al,30h     ; convert hex to ASCII
        cmp  al,3ah     ; is it > 9?
        jl   printit    ; jump if digit =0 or 9
        add  al,7h      ; digit is A to F
printit:
        mov  dl,al      ; put ASCII char in DL
        mov  ah,2       ; Display Output funct
        int  21h        ; call DOS
        dec  ch         ; done 4 digits?
        jnz  rotate     ; not yet

        int  20h        ; return to DEBUG

prognam ends

        end
```

```
debug binihex.com
-rbx
BX 0000
:1234
-g
1234
```

DECIBIN.ASM:

```
; DECIBIN--Program to get decimal digits
;          from keyboard and convert them
;          to binary number in BX

prognam segment

        assume cs:prognam

        mov     bx,0    ; clear BX for number

; Get digit from keyboard, convert to binary
newchar:
        mov  ah,1       ; keyboard input
        int  21h        ; call DOS
        sub  al,30h     ; ASCII to binary
        jl   exit       ; jump if < 0
        cmp  al,9d      ; is it > 9d ?
        jg   exit       ; yes, not dec digit
        cbw  ; byte in AL to word in AX
; (digit is now in A)
; Multiply number in BX by 10 decimal
        xchg ax,bx      ; trade digit & number
        mov  cx,10d     ; put 10 dec in CX
        mul  cx         ; number times 10
        xchg ax,bx      ; trade number & digit

; Add digit in AX to number in BX
        add  bx,ax      ; add digit to number
        jmp  newchar    ; get next digit

exit:
        int 20h

prognam ends

        end
```

DECIHEX.ASM:

```
; DECIHEX--Main Program
;   Converts decimal on keybd to hex on screen
; *********************************************

decihex segment
        assume cs:decihex

; MAIN PART OF PROGRAM.  Connects procedures
;   together.

repeat: call    decibin ;keyboard to binary
        call    crlf    ;print cr and lf

        call    binihex ;binary to screen
        call    crlf    ;print cr and lf

        jmp     repeat  ;do it again

;---------------------------------------------
;PROCEDURE TO CONVERT DEC ON KEYBD TO BINARY
;  Result is left in BX register

decibin proc    near

        mov     bx,0    ;clear BX for number

;Get digit from keyboard, converto to binary
newchar:
        mov     ah,1    ;keyboard input
        int     21h     ;call DOS
        sub     al,30h  ;ASCII to binary
        jl      exit    ;jump if < 0
        cmp     al,9d   ;is it > 9d ?
        jg      exit    ;yes, not dec digit
        cbw     ;byte in AL to word in AX
;(digit is now in AX)

;Multiply number in bx by 10 decimal
        xchg    ax,bx   ;trade digit & number
        mov     cx,10d  ;put 10 dec in CX
        mul     cx      ;number times 10
        xchg    ax,bx   ;trade number & digit

;Add digit in ax to number in bx
        add     bx,ax   ;add digit to number
        jmp     newchar ;get next digit
exit:
        ret             ;return from decibin

decibin endp

;---------------------------------------------
;PROCEDURE TO CONVERT BINARY NUMBER IN BX
;  TO HEX ON CONSOLE SCREEN

binihex proc    near

        mov     ch,4    ;number of digits
rotate: mov     cl,4    ;set count to 4 bits
        rol     bx,cl   ;left digit to right
        mov     al,bl   ;move to AL
        and     al,0fh  ;mask off left digit
        add     al,30h  ;convert hex to ASCII
        cmp     al,3ah  ;is it > 9 ?
        jl      printit ;jump if digit = 0 to 9
        add     al,7h   ;digit is A to F
printit:
        mov     dl,al   ;put ASCII char in DL
        mov     ah,2    ;Display Output funct
        int     21h     ;call DOS
        dec     ch      ;done 4 digits?
        jnz     rotate  ;not yet

        ret             ;return from binihex

binihex endp

;---------------------------------------------
;PROCEDURE TO PRINT CARRIAGE RETURN
;        AND LINEFEED

crlf    proc    near

        mov     dl,0dh  ;carriage return
        mov     ah,2    ;display function
        int     21h     ;call DOS

        mov     dl,0ah  ;linefeed
        mov     ah,2    ;display function
        int     21h     ;call DOS

        ret             ;return from crlf

crlf    endp

;---------------------------------------------
decihex ends
;*********************************************

        end
```

PAGE turns on line numbering on LST.

```
        page

; DECIHEX--Main Program
...
```

Check out CREF program.

## 7 - How Does It Sound?

The White Noise Program:

```
;NOISE--Makes a sound with the speaker
;  can't be stopped except by reset
;*********************************************

prognam segment ;define code segment

;---------------------------------------------
main    proc    far     ;main part of the program

        assume  cs:program

        org     100h    ;start of program

start:                  ;starting execution address

        mov     dx,140h ;initial value of wait

        in      al,61h      ;get port 61
        and     al,11111100b    ;AND off bits 0,1
sound:  xor     al,2        ;toggle bit #1 in AL
        out     61h,al      ;output to port 61
        add     dx,9248h    ;add random pattern
        mov     cl,3        ;set to rotate 3 bits
        ror     dx,cl       ;rotate it

        mov     cx,dx       ;put in CX
        and     cx,1ffh     ;mask off upper 7 bits
        or      cx,10       ;ensure not too short

wait:   loop    wait        ;wait
        jmp     sound       ;keep on toggling

main    endp        ;end of main part of program
;---------------------------------------------
prognam ends        ;end of code segment
;*********************************************

        end     start       ;end assembly
```

The Machine Gun Program:

```
;GUN--Makes machine gun sound
;  fires fixed number of shots
;*********************************************

prognam segment ;define code segment

;---------------------------------------------
main    proc    far         ;main part of program

        assume  cs:program

        org     100h        ;start of program

start:          ;starting execution address

        mov     cx,20d      ;set number of shots
new_shot:
        push    cx          ;save count
        call    shoot       ;sound of shot
        mov     cx,4000h    ;set up silent delay
silent: loop    silent      ;silent delay
        pop     cx          ;get shots count back
        loop    new_shot    ;loop till shots done
        int     20h         ;return to DOS

main    endp    ;end of main part of program
;---------------------------------------------
;SUBROUTINE TO MAKE BRIEF NOISE

shoot   proc    near

        mov     dx,140h     ;initial value of wait
        mov     bx,20h      ;set count

        in      al,61h      ;get port 61h
        and     al,11111100b ;AND off bits #0, #1

sound:  xor     al,2        ;toggle bit #1 in AL
        out     61h,al      ;toggle to port 61

        add     dx,9248h    ;add random bit pattern
        mov     cl,3        ;set to rotate 3 bits
        ror     dx,cl       ;rotate it

        mov     cx,dx       ;put in CX
        and     cx,1ffh     ;mask off upper 7 bits
        or      cx,10       ;ensure not too short

wait:   loop    wait        ;wait


;made noise long enough?
        dec     bx          ;done enough?
        jnz     sound       ;jump if not yet

;turn off sound
        and     al,11111100b ;AND off bits 0, 1
        out     61h,al      ;turn off bits 0, 1

        ret                 ;return from subr

shoot   endp
;---------------------------------------------
prognam ends        ;end of code segment
;*********************************************

        end     start       ;end assembly
```

The SIREN Program:

