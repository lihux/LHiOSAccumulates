
114_mstore.o:	file format Mach-O 64-bit x86-64

Disassembly of section __TEXT,__text:
_mulstore:
       0:	55 	pushq	%rbp
       1:	48 89 e5 	movq	%rsp, %rbp
       4:	48 83 ec 20 	subq	$32, %rsp
       8:	48 89 7d f8 	movq	%rdi, -8(%rbp)
       c:	48 89 75 f0 	movq	%rsi, -16(%rbp)
      10:	48 89 55 e8 	movq	%rdx, -24(%rbp)
      14:	48 8b 7d f8 	movq	-8(%rbp), %rdi
      18:	48 8b 75 f0 	movq	-16(%rbp), %rsi
      1c:	e8 00 00 00 00 	callq	0 <_mulstore+0x21>
      21:	48 89 45 e0 	movq	%rax, -32(%rbp)
      25:	48 8b 45 e0 	movq	-32(%rbp), %rax
      29:	48 8b 55 e8 	movq	-24(%rbp), %rdx
      2d:	48 89 02 	movq	%rax, (%rdx)
      30:	48 83 c4 20 	addq	$32, %rsp
      34:	5d 	popq	%rbp
      35:	c3 	retq
