#include<stdio.h>

int lihux () {
	return (int)^{int a = 1; int b = a + 1;  return b;}();
}

int main() {
	^{ printf("Hello world!\n");}();
	return lihux();
}
