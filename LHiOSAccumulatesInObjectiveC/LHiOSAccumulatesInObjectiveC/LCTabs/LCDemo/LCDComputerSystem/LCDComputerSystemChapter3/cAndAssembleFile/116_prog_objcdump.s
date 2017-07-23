
116_prog:	file format Mach-O 64-bit x86-64

Disassembly of section __TEXT,__text:
__text:
100000ee0:	55 	pushq	%rbp
100000ee1:	48 89 e5 	movq	%rsp, %rbp
100000ee4:	48 83 ec 20 	subq	$32, %rsp
100000ee8:	b8 02 00 00 00 	movl	$2, %eax
100000eed:	89 c7 	movl	%eax, %edi
100000eef:	b8 03 00 00 00 	movl	$3, %eax
100000ef4:	89 c6 	movl	%eax, %esi
100000ef6:	48 8d 55 f0 	leaq	-16(%rbp), %rdx
100000efa:	c7 45 fc 00 00 00 00 	movl	$0, -4(%rbp)
100000f01:	e8 4a 00 00 00 	callq	74 <_multstore>
100000f06:	48 8d 3d 99 00 00 00 	leaq	153(%rip), %rdi
100000f0d:	48 8b 75 f0 	movq	-16(%rbp), %rsi
100000f11:	b0 00 	movb	$0, %al
100000f13:	e8 6e 00 00 00 	callq	110
100000f18:	31 c9 	xorl	%ecx, %ecx
100000f1a:	89 45 ec 	movl	%eax, -20(%rbp)
100000f1d:	89 c8 	movl	%ecx, %eax
100000f1f:	48 83 c4 20 	addq	$32, %rsp
100000f23:	5d 	popq	%rbp
100000f24:	c3 	retq
100000f25:	66 66 2e 0f 1f 84 00 00 00 00 00 	nopw	%cs:(%rax,%rax)
100000f30:	55 	pushq	%rbp
100000f31:	48 89 e5 	movq	%rsp, %rbp
100000f34:	48 89 7d f8 	movq	%rdi, -8(%rbp)
100000f38:	48 89 75 f0 	movq	%rsi, -16(%rbp)
100000f3c:	48 8b 75 f8 	movq	-8(%rbp), %rsi
100000f40:	48 0f af 75 f0 	imulq	-16(%rbp), %rsi
100000f45:	48 89 75 e8 	movq	%rsi, -24(%rbp)
100000f49:	48 8b 45 e8 	movq	-24(%rbp), %rax
100000f4d:	5d 	popq	%rbp
100000f4e:	c3 	retq
100000f4f:	90 	nop
100000f50:	55 	pushq	%rbp
100000f51:	48 89 e5 	movq	%rsp, %rbp
100000f54:	48 83 ec 20 	subq	$32, %rsp
100000f58:	48 89 7d f8 	movq	%rdi, -8(%rbp)
100000f5c:	48 89 75 f0 	movq	%rsi, -16(%rbp)
100000f60:	48 89 55 e8 	movq	%rdx, -24(%rbp)
100000f64:	48 8b 7d f8 	movq	-8(%rbp), %rdi
100000f68:	48 8b 75 f0 	movq	-16(%rbp), %rsi
100000f6c:	e8 bf ff ff ff 	callq	-65 <_mult2>
100000f71:	48 89 45 e0 	movq	%rax, -32(%rbp)
100000f75:	48 8b 45 e0 	movq	-32(%rbp), %rax
100000f79:	48 8b 55 e8 	movq	-24(%rbp), %rdx
100000f7d:	48 89 02 	movq	%rax, (%rdx)
100000f80:	48 83 c4 20 	addq	$32, %rsp
100000f84:	5d 	popq	%rbp
100000f85:	c3 	retq

_main:
100000ee0:	55 	pushq	%rbp
100000ee1:	48 89 e5 	movq	%rsp, %rbp
100000ee4:	48 83 ec 20 	subq	$32, %rsp
100000ee8:	b8 02 00 00 00 	movl	$2, %eax
100000eed:	89 c7 	movl	%eax, %edi
100000eef:	b8 03 00 00 00 	movl	$3, %eax
100000ef4:	89 c6 	movl	%eax, %esi
100000ef6:	48 8d 55 f0 	leaq	-16(%rbp), %rdx
100000efa:	c7 45 fc 00 00 00 00 	movl	$0, -4(%rbp)
100000f01:	e8 4a 00 00 00 	callq	74 <_multstore>
100000f06:	48 8d 3d 99 00 00 00 	leaq	153(%rip), %rdi
100000f0d:	48 8b 75 f0 	movq	-16(%rbp), %rsi
100000f11:	b0 00 	movb	$0, %al
100000f13:	e8 6e 00 00 00 	callq	110
100000f18:	31 c9 	xorl	%ecx, %ecx
100000f1a:	89 45 ec 	movl	%eax, -20(%rbp)
100000f1d:	89 c8 	movl	%ecx, %eax
100000f1f:	48 83 c4 20 	addq	$32, %rsp
100000f23:	5d 	popq	%rbp
100000f24:	c3 	retq
100000f25:	66 66 2e 0f 1f 84 00 00 00 00 00 	nopw	%cs:(%rax,%rax)

_mult2:
100000f30:	55 	pushq	%rbp
100000f31:	48 89 e5 	movq	%rsp, %rbp
100000f34:	48 89 7d f8 	movq	%rdi, -8(%rbp)
100000f38:	48 89 75 f0 	movq	%rsi, -16(%rbp)
100000f3c:	48 8b 75 f8 	movq	-8(%rbp), %rsi
100000f40:	48 0f af 75 f0 	imulq	-16(%rbp), %rsi
100000f45:	48 89 75 e8 	movq	%rsi, -24(%rbp)
100000f49:	48 8b 45 e8 	movq	-24(%rbp), %rax
100000f4d:	5d 	popq	%rbp
100000f4e:	c3 	retq
100000f4f:	90 	nop

_multstore:
100000f50:	55 	pushq	%rbp
100000f51:	48 89 e5 	movq	%rsp, %rbp
100000f54:	48 83 ec 20 	subq	$32, %rsp
100000f58:	48 89 7d f8 	movq	%rdi, -8(%rbp)
100000f5c:	48 89 75 f0 	movq	%rsi, -16(%rbp)
100000f60:	48 89 55 e8 	movq	%rdx, -24(%rbp)
100000f64:	48 8b 7d f8 	movq	-8(%rbp), %rdi
100000f68:	48 8b 75 f0 	movq	-16(%rbp), %rsi
100000f6c:	e8 bf ff ff ff 	callq	-65 <_mult2>
100000f71:	48 89 45 e0 	movq	%rax, -32(%rbp)
100000f75:	48 8b 45 e0 	movq	-32(%rbp), %rax
100000f79:	48 8b 55 e8 	movq	-24(%rbp), %rdx
100000f7d:	48 89 02 	movq	%rax, (%rdx)
100000f80:	48 83 c4 20 	addq	$32, %rsp
100000f84:	5d 	popq	%rbp
100000f85:	c3 	retq
Disassembly of section __TEXT,__stubs:
__stubs:
100000f86:	ff 25 84 00 00 00 	jmpq	*132(%rip)
Disassembly of section __TEXT,__stub_helper:
__stub_helper:
100000f8c:	4c 8d 1d 75 00 00 00 	leaq	117(%rip), %r11
100000f93:	41 53 	pushq	%r11
100000f95:	ff 25 65 00 00 00 	jmpq	*101(%rip)
100000f9b:	90 	nop
100000f9c:	68 00 00 00 00 	pushq	$0
100000fa1:	e9 e6 ff ff ff 	jmp	-26 <__stub_helper>
