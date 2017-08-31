	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_main
	.p2align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp0:
	.cfi_def_cfa_offset 16
Ltmp1:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp2:
	.cfi_def_cfa_register %rbp
	callq	_getpid
	movl	%eax, %ecx
	leaq	L_.str(%rip), %rdi
	xorl	%eax, %eax
	movl	%ecx, %esi
	callq	_printf
	callq	_getppid
	movl	%eax, %ecx
	leaq	L_.str.1(%rip), %rdi
	xorl	%eax, %eax
	movl	%ecx, %esi
	callq	_printf
	xorl	%eax, %eax
	popq	%rbp
	retq
	.cfi_endproc

	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"\345\275\223\345\211\215\350\277\233\347\250\213ID\357\274\232%d\n"

L_.str.1:                               ## @.str.1
	.asciz	"\345\275\223\345\211\215\350\277\233\347\250\213\347\232\204\347\210\266\350\277\233\347\250\213ID\357\274\232%d\n"


.subsections_via_symbols
