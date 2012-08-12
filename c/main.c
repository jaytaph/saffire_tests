#include <stdio.h>
#include "c.tab.h"

extern int      yyparse();
extern FILE     *yyin;

int main(int argc, char *argv[]) {
    // Open file, or use stdin if needed
    FILE *fp = fopen("testfile.c", "r");

    // Parse the file input
    yyin = fp;
    yyparse();
}
