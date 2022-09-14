100 ' Test Program for Chapter 1
110 '
120   DEF SEG=&H1F94
130   BINOUT = &H15
140 '
150 ' get the number
160   INPUT "type a number";X%
170 '
180 ' print the number
190   CALL BINOUT(X%)
200   PRINT
210 '
220   GOTO 150