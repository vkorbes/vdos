; Display of Floating Point

; Function: 
; This routine displays a floating point number on the standard
; output device.

; Input: 
; Upon input a number is stored in temporary decimal floating
; point form. The temporary format has a string of 25 decimal digits, a
; sign byte, and a base ten exponent which is stored in two's complement
; 16-bit binary format.

; Output: 
; The individual characters of a floating point number are sent
; out the standard output device. The form of the output is: a sign
; character which is blank or minus, followed by decimal digits of the
; mantissa with one embedded decimal point to the right of the first
; significant digit. Following the mantissa is an exponent which starts with
; the letter E, then a sign, then a decimal number.

; Registers used: 
; AL, CX, DX, and SI are modified.

; Segments referenced:
; The data segment contains the variables DECBUFF
; (25 bytes), DESIGN (1 byte), and DECEXP (2 bytes).

; Routines called: 
; STDOUT

; Special notes: 
; This is a near procedure needed by FPOUT.



; ROUTINE TO DISPLAY TEMPORARY DECIMAL FLOATING POINT NUMBERS
;
tdecshow        proc    near
;
; output the sign
        cmp     decsign,0       ; is the sign there?
        mov     al,' '          ; space if not
        je      tdecshow1
;
; output a minus sign
        mov     al,'-'          ; minus sign
tdecshow1:
        call    stdout          ; send it out
;
tdecshow2:
; output the first digit and a decimal point
        lea     si,decbuff+21   ; point to first digit
        mov     al,[si]         ; get it
        dec     si              ; point to next digit
        add     al,30h          ; make it ASCII
        call    stdout          ; send it out
;
        mov     al,'.'          ; ASCII decimal point
        call    stdout          ; send it out
;
; output the rest of the decimal string
        mov     cx,7            ; only 7 more digits
tdecshow3:
        mov     al,[si]         ; get digit
        dec     si              ; point to next digit
        add     al,30h          ; make ASCII
        call    stdout          ; send it out
        loop    tdecshow3
;
        mov     al,'E'          ; E for exponent
        call    stdout          ; send it out
;
; now the exponent
        mov     dx,decexp       ; grab exponent
        cmp     dx,0            ; check sign
        mov     al,'+'          ; plus sign
        jge     tdecshow4       ; if nonnegative
;
; if negative exponent
        neg     dx              ; absolute value of exponent
        mov     al,'-'          ; minus sign
;
tdecshow4:
        call    stdout          ; output sign of exponent
        call    dec16out        ; output exponent
;
        ret                     ; return
;
tdecshow        endp