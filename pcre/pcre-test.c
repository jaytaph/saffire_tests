#include "pcre.h"
#include <stdio.h>
#include <string.h>

#define OVECCOUNT 30

int main(int argc, char *argv) {
	const char *error;
	int error_offset;
	int ovector[OVECCOUNT];

	char str[] = "fo1o blaat fo2ofo3o! fo4oooo fo foo";

	pcre *re  = pcre_compile("(fo)(\\d)", 0, &error, &error_offset, 0);
	if (! re) {
		printf("compile failed: (offset: %d), %s\n", error_offset, error);
		return 1;
	}

	int offset = 0;
	int rc;
	do {
		rc = pcre_exec(re, 0, str, strlen(str), offset, 0, ovector, OVECCOUNT);
		printf("RC: %d\n", rc);
		if (rc < 0) {
			switch (rc) {
				case PCRE_ERROR_NOMATCH:
					printf("String didn't match");
					break;
				default:
					printf("Error while matching: %d\n", rc);
					break;
			}
			free(re);
			return 1;
		}

		const char **result;
		int c = pcre_get_substring_list(str, ovector, rc, &result);
		printf("C: %d\n", c);

		int i;
		for (i=0; i<rc; i++) {
			printf("%d: %s\n", i, result[i]);
		}

		offset = ovector[1];
	} while (rc > 0);


	pcre_free(re);
	return 0;
}

