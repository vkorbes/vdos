; Conversion from 16-Bit Integer to Floating Point

; Function:
; This routine converts an unsigned 16-bit binary number to a
; single precision binary floating point number.

; Input:
; Upon entry DX contains an unsigned 16-bit binary number.

; Output:
; Upon exit SFPBUFF contains a single precision floating point
; number. The single precision floating point number has a 24-bit binary
; mantissa, a sign bit, and an 8-bit exponent biased by 128.

; Registers used:
; No registers are modified. DX is used for input.

; Segments referenced:
; The data segment contains storage for the variable
; SFPBUFF and the message INTERNAL

; Routines called:
; MESSOUT, HEX16OUT, STDSPACE (all for debugging)

; Special notes:
; Equates are used to shorten address fields.



; ROUTINE TO CONVERT FROM INTERNAL INTEGER TO INTERNAL FLOATING POINT
;
float   proc    far
;
; the number is in DX
;
        push    dx              ; save registers
        push    cx
        push    ax
;
        mov     ax,0            ; extend to 32 bits
        cmp     dx,0            ; check if zero
        jz      float4
;
float1:
        mov     cx,9800h        ; initialize exponent and sign
; shift left until normalized
float2:
        test    ax,0080h        ; done yet?
        jnz     float3          ; exit if so
        sal     dx,1            ; shift all bits left if not
        rcl     ax,1            ; carry on
        dec     ch              ; decrement the exponent
        jmp     float2
;
float3:
;
; pack it in
        and     ax,007Fh        ; just the mantissa
        or      ax,cx           ; exponent and sign
;
float4:
        mov     sfpbuffw0,dx    ; put lower part into place
        mov     sfpbuffw2,dx    ; put upper part into place
;
; show hex for debugging
        lea     si,internal     ; point to message
        call    stdmessout      ; send message
;
        mov     dx,sfpbuffw2    ; upper word
        call    hex16out        ; show it
;
        call    stdspace        ; skip space
;
        pop     ax              ; restore registers
        pop     cx  
        pop     dx
        ret                     ; return
;
float   endp