#include <stdio.h>

#define TAB_WIDTH       8

#define TAB             '\x09'
#define LF              '\x0A'
#define FF              '\x0C'
#define CR              '\x0D'
#define EOF_MARK        '\x1A'
#define BLANK           '\x20'


main(argc,argv)
int     argc;
char    *argv[];

{   char c;
    int col = 0;

    while( (c = getchar() ) != EOF )
    {   c &= 0x07F;
        switch(c)
        {   case LF:
            case CR:
                col=0;
            case FF:
                writechar(c);
                break;
            case TAB:
                do writechar(BLANK);
                write( ( ++col % TAB_WIDTH ) != 0 );
                break;
            default:
                if (c >= BLANK)
                {   writechar(c);
                    col++;
                }
                break;
        }
    }
    writechar(EOF_MARK);
    exit(0);
}

writechar(c)
char c;

{   if( (putchar(c) == EOF) && (c != EOF_MARK) )
    {   fputs("clean: disk full",stderr);
        exit(1);
    }
}