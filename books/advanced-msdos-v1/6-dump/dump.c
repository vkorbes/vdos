/*
    DUMP.C
*/

#include <stdio.h>

#define REC_SIZE 128

main(argc, argv)
    int     argc;
    char    *argv[];

{   FILE *dfile;
    int status = 0;
    int file_rec = 0;
    long file_ptr = 0L;
    char file_buf[REC_SIZE];

    if (argc != 2)
        {   fprintf(stderr,"\ndump: wrong number of parameters\n");
            return(1);
        }

    if ( (dfile = fopen(argv[1],"rb") ) == NULL)
        {   fprintf( stderr, "\ndump: can't find file: %s \n", argv[1] );
            return(1);
        }

    printf( "\Dump of file: %s ", argv[1] );

    while ( (status = fread(file_buf,1,REC_SIZE,dfile) ) != 0 )
        {   dump_rec(file_buf,++file_rec,file_ptr);
            file_ptr += REC_SIZE;
        }

    printf("\n\n");
    fclose(dfile);
    return(0);
}

dump_rec(file_buf,file_rec,file_ptr)
    char *file_buf;
    int file_rec;
    long file_ptr;

{   int i;

    printf("\n\nRecord %04X",file_rec);

    printf("\n       0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F");

    for(i = 0; i < REC_SIZE; i += 16)
        dump_para( file_ptr+1,file_buf+i );
}

dump_para(file_ptr,para_ptr)
    long file_ptr;
    unsigned char *para_ptr;

{   int j;
    char c;

    printf("\n%04lX ",file_ptr);

    for(j = 0; j < 16; j++)
        printf( " %02X", para_ptr[j] );
    printf("  ");

    for(j = 0; j < 16; j++)
        {   c = para_ptr[j];
            if( (c < 32) | (c > 126) )
                c = '.' ;
            putchar(c);
        }
}