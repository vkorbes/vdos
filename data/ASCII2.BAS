100 ' TEXT
110 '
120 ' Displays text characters in
130 ' various colors.
140 '
150   SCREEN 0,1
160   WIDTH 40
170   CLS
180 '
190   PRINT TAB(18);"TEXT"
200 '
210   PRINT:PRINT:PRINT
220   FOR I = 0 TO 7
230    FOR J = 0 TO 31
240     COLOR J, I, 1
250     PRINT "A";
260    NEXT J
270    PRINT
280   NEXT I
290
300   COLOR 15,0 1