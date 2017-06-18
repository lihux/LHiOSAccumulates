#include<stdio.h>

int lihux () {
	__block int a = 1;
	return (int)^{ int b = a + 1; a += b;  return b;}();
}

int main() {
	^{ printf("Hello world!\n");}();
	return lihux();
}
