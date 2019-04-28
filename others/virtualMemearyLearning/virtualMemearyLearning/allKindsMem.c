#include <stdlib.h>

int global_j;
const int ci = 24;

void main ( int argc, char **argv) {
	int local_stack = 0;
	char *const_data = "This data is constant";
	char *tiny = malloc(32);//分配32bytes
	char *small = malloc(2 * 1024);//分配2K字节
	char *large = malloc (1 * 1024 * 1024);//分配1M字节

	printf("Text is %p\n", main);
	printf("Global data is %p\n", &global_j);
	printf("local (stack) is  %p\n", &local_stack);
	printf("constant data is %p\n", &ci);
	printf("hardcoded string (also constant) are at %p\n", const_data);
	printf("tiny allocations from %p\n", tiny);
	printf("small allocations from %p\n", small);
	printf("large allocations from %p\n", large);
	printf("malloc (libSystem) is at %p\n", malloc);
	sleep(1000);
}
