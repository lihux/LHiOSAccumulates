	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_combine1
	.p2align	4, 0x90
_combine1:                              ## @combine1
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
	pushq	%r15
	pushq	%r14
	pushq	%rbx
	pushq	%rax
Ltmp3:
	.cfi_offset %rbx, -40
Ltmp4:
	.cfi_offset %r14, -32
Ltmp5:
	.cfi_offset %r15, -24
	movq	%rsi, %r14
	movq	%rdi, %r15
	callq	_vec_length
	movq	%rax, %rbx
	movq	%r15, %rdi
	callq	_get_vec_start
	movl	$1, %ecx
	testq	%rbx, %rbx
	jle	LBB0_2
	.p2align	4, 0x90
LBB0_1:                                 ## =>This Inner Loop Header: Depth=1
	imulq	(%rax), %rcx
	addq	$8, %rax
	decq	%rbx
	jne	LBB0_1
LBB0_2:
	movq	%rcx, (%r14)
	leaq	L_.str(%rip), %rax
	addq	$8, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.cfi_endproc

	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"\351\200\232\350\277\207\347\264\257\350\256\241\345\217\230\351\207\217\344\274\230\345\214\226\345\276\252\347\216\257\344\270\255\346\257\217\346\254\241\351\203\275\350\246\201\345\276\200\345\206\205\345\255\230\344\270\255\345\206\231\346\225\260\346\215\256\357\274\232combine4"


.subsections_via_symbols
