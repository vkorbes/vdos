; Draw a Line

; Function:
; This routine draws a line from (x1,y1) to (x2,y2) in the
; specified color. It uses Bresenham's algorithm.

; Input:
;     Upon entry:
;     x1 contains -coordinate of starting point
;     y1 contains y-coordinate of starting point
;     x2 contains x-coordinate of ending point
;     v2 contains y-coordinate of ending point
;     color contains the color of the line

; Output: 
; Just to the screen.

; Registers Used:
; No registers are modified.

; Segments Referenced:
; Upon entry ES must point to the video RAM at
; B8000h and DS must point to a data segment used by the point-plotting
; routine (see SEPT or XORPT above).

; Routines Called: 
; SETPT

; Special Notes:
; No bounds checking is performed. The user must make
; sure that the coordinates and the color are in their proper ranges. That
; is, x1 and x2 must be between 0 and 319, y1 and y2 must be between 0
; and 199, and color must be between 0 and 3.



; ROUTINE TO DRAW LINE
;
setline proc    far
        push    bx              ; save registers
        push    cx
        push    dx
        push    si
        push    di
        push    ax
;
; set up x and y updates
        mov     si,1            ; start with positive 1 for x update
        mov     di,1            ; start with positive 1 for y update
;
; find |y2-y1|
        mov     dx,y2           ; get y2
        sub     dx,y1           ; subtract y1
        jge     storey          ; skip if y2-y1 is nonnegative
        neg     di              ; move in negative y direction
        neg     dx              ; absolute value of y2-y1
storey:
        mov     deldy,di        ; store y update for diagonal moves
;
; find |x2-x1|
        mov     cx,c2           ; get x2
        sub     cx,c1           ; subtract x1
        jge     storex          ; skip if x2-x1 is nonnegative
        neg     si              ; move in negative x direction
        neg     cx              ; absolute value of x2-x1
storex:
        mov     deldx,si        ; store x update for diagonal moves
;
; sort |y2-y1| and |x2-x1|
        cmp     cx,dx           ; compare dels with delp
        jge     setdiag         ; skip if straight moves in x direction
        mov     si,0            ; if straight=vertical: kill x update
        xchg    cx,dx           ;    and exchange differences
        jmp     storedelsxy
;
setdiag:
        mov     di,0            ; if straight=horizontal: kill y update
;
; store dels, delp, delsx, and delsy
storedelsxy:
        mov     dels,cx         ; change in straight direction
        mov     delp,dx         ; change in perpendicular to straight
        mov     delsx,si        ; x update in straight direction
        mov     delsy,di        ; y update in straight direction
;
; get initial values for x and y
        mov     si,x1           ; x-coordinate
        mov     di,y1           ; y-coordinate
;
; compute initial value and increments for error function
        mov     ax,delp         
        sal     ax,1            ; 2*delp
        mov     delse,ax        ; change if straight move
;
        sub     ax,cx           ; 2*delp - dels
        mov     bx,ax           ; initial value
;
        sub     ax,cx           ; 2*delp - 2*dels
        mov     delde,ax        ; change if diagonal move
;
; adjust count
        inc     cx
;
; set the color
        mov     dx,color        ; get the color
;
; main loop structure
lineloop:
        call    setpt           ; plot the point
        cmp     bx,0            ; determine straight or diagonal move
        jge     diagonal
;
; case for straight move
straight:
        add     si,delsx        ; update x
        add     di,delsy        ; update y
        add     bx,delse        ; update error term
        loop    lineloop        ; next point
        jmp     lineexit
;
; case for diagonal move
diagonal:
        add     si,deldx        ; update x
        add     di,deldy        ; update y
        add     bx,delde        ; update error term
        loop    lineloop
;
lineexit:
        pop     ax              ; restore registers
        pop     di
        pop     si
        pop     dx
        pop     cx
        pop     bx
        ret
;
setline endp