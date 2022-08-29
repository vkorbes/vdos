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