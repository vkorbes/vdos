; Bubble Sort a String Array

; Function:
; This routine sorts a string array using bubble sort.

; Input:
; Upon entry DS:SI points to a string array, CX contains the
; number of entries in the array, and DX contains the size of each entry.

; Output:
; Upon exit the array is sorted.

; Registers Used:
; No registers are modified.

; Segments Referenced:
; Upon entry the data segment and the extra
; segment must be equal and must contain the string array.

; Routines Called: 
; COMPARE, SWITCH

; Special Notes:
; None



; ROUTINE TO SORT A STRING ARRAY
;
bsort   proc    far
;
        push    si              ; save registers
        push    di
        push    cx
        push    ax
;
; adjust count for one less than number of items
        dec     cx              ; adjust the count
;
; outer loop - for SI = 1 to N-1
bsort1:
        push    cx              ; save the count
        mov     di,si           ; destination points to source
;
; inner loop - for DI = SI+1 to N
bsort2:
        push    cx              ; save the count
        add     di,dx           ; point to next destination
        mov     cx,dx           ; entry length
        call    compare         ; compare the strings
        jle     bsort3          ; skip if source <= dest
        call    switch          ; switch if not
;
bsort3:
        pop     cx              ; restore the count
        loop    bsort2
;
        add     si,dx           ; point to next source
        pop     cx              ; restore the count
        loop    bsort1
bsortexit:
        pop     ax              ; restore registers
        pop     cx
        pop     di
        pop     si
        ret
;
bsort   endp