/*

        TRYBREAK.C

*/

#include <stdio.h>

main(argc, argv)
    int argc;
    char *argv[];
    {   int hit = 0;
        int c = 0;
        static int flag = 0;

        puts("\n*** TRYBREAK.C running ***\n");
        puts("Press Ctrl-C or Ctrl-Break to test handler,");
        puts("Press the Esc key to exit TRYBREAK.\n");

        capture(&flag);

        puts("TRYBREAK has CAPTUREd interrupt vectors.\n");

        while ( (c&127) != 27 )
        {   hit = kbhit();
            if (flag != 0)
                    { puts("\nCtrl-Break detected.\n");
                      flag=0;
                    }
            if (hit != 0)
             {  c=getch();
                putch(c);
             }
        }
        release();
        puts("\nTRYBREAK has RELEASEd interrupt vectors.")
        
    }