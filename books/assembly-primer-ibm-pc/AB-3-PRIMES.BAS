10 DEFINT A-Z
20 DIM MARK(16381)
25 COUNT=0
30 FOR I=3 TO 16381 STEP 2
40    MARK(I)=0
50 NEXT I
60 FOR I=3 TO 16381 STEP 2
70    IF MARK(I)=1 THEN GOTO 130
80    'PRINT I;
85    COUNT=COUNT+1
90    J=I
100   FOR J=J+I TO 16381 STEP I
110      MARK(J)=1
120   NEXT J
130 NEXT I
135 PRINT : PRINT COUNT "primes"
140 STOP