#include <wchar.h>
#include <stdio.h>

void main(int argc, char *argv[]) {
    wchar_t s[100] = L"∮∮∮∮ሰማይ";
    wchar_t d[100];

    printf("The string entered has a length of %d\n\n", wcslen(s));

    wcsncpy(d, s, 3);
    d[3] = '\0';

    printf("The string entered has a length of %d\n\n", wcslen(d));

    wcsncpy(d, s+3, 2);
    d[2] = '\0';

    printf("The string entered has a length of %d\n\n", wcslen(d));

}