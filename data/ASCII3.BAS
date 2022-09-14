100 ' MANDALA
110 '
120 ' this program draws a mandala
130 ' and then prints the title
140 ' "ibm pc" in the center with
150 ' large letters.
160 '
170   SCREEN 2 ' HIGH RES GRAPHICS
180   KEY OFF
190   CLS
200 '
210   FOR I = 0 TO 20
220    X1 = 32*I
230    X2 = 640 - 32*I
240    Y1 = 10*I
250    Y2 = 200 - 10*I
260    LINE (X1,0)-(640,Y1)
270    LINE (X1,200)-(640,Y2)
280    LINE (X2,0)-(0,Y1)
290    LINE (X2,200)-(0,Y2)
300   NEXT I
310 '
320 ' border of pointers
330   FOR X = 160 TO 480 STEP 8
340    PSET (X,70)
350    PSET (X,130)
360   NEXT X
370 '
380   FOR Y = 70 TO 130 STEP 4
390    PSET (160,Y)
400    PSET (480,Y)
410   NEXT Y
420 ' the letter I
430   LINE (200,80)-(200,120)
440   LINE (192,80)-(208,80)
450   LINE (192,120)-(208,120)
460 '
470 ' the letter B
480   PSET (248,100)
490   LINE -(256,104)
500   LINE -(256,116)
510   LINE -(248,120)
520   LINE -(224,120)
530   LINE -(224,80)
540   LINE -(248,80)
550   LINE -(256,84)
560   LINE -(256,96)
570   LINE -(248,100)
580   LINE -(224,100)
590 '
600 ' the letter M
610   PSET (280,120)
620   LINE -(280,80)
630   LINE -(296,88)
640   LINE -(304,88)
650   LINE -(320,80)
660   LINE -(320,120)
670 '
680 ' the letter P
690   PSET (360,120)
700   LINE -(360,80)
710   LINE -(384,80)
720   LINE -(392,84)
730   LINE -(392,96)
740   LINE -(384,100)
750   LINE -(360,100)
760 '
770 ' the letter c
780   PSET (448,116)
790   LINE -(440,120)
800   LINE -(424,120)
810   LINE -(416,116)
820   LINE -(416,84)
830   LINE -(424,80)
840   LINE -(440,80)
850   LINE -(448,84)