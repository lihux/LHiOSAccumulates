#include<stdio.h>

int lihux () {
	int a = 1;
	return (int)^{ int b = a + 1;  return b;}();
}

int main() {
	^{ printf("Hello world!\n");}();
	return lihux();
}
