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
	subq	$64, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	$1, -32(%rbp)
	movq	-8(%rbp), %rdi
	callq	_vec_length
	movq	%rax, -40(%rbp)
	movq	-8(%rbp), %rdi
	callq	_get_vec_start
	movq	%rax, -48(%rbp)
	movq	$0, -24(%rbp)
LBB0_1:                                 ## =>This Inner Loop Header: Depth=1
	movq	-24(%rbp), %rax
	cmpq	-40(%rbp), %rax
	jge	LBB0_4
## BB#2:                                ##   in Loop: Header=BB0_1 Depth=1
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rcx
	movq	-48(%rbp), %rdx
	imulq	(%rdx,%rcx,8), %rax
	movq	%rax, -32(%rbp)
## BB#3:                                ##   in Loop: Header=BB0_1 Depth=1
	movq	-24(%rbp), %rax
	addq	$1, %rax
	movq	%rax, -24(%rbp)
	jmp	LBB0_1
LBB0_4:
	leaq	L_.str(%rip), %rax
	movq	-32(%rbp), %rcx
	movq	-16(%rbp), %rdx
	movq	%rcx, (%rdx)
	addq	$64, %rsp
	popq	%rbp
	retq
	.cfi_endproc

	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"\351\200\232\350\277\207\347\264\257\350\256\241\345\217\230\351\207\217\344\274\230\345\214\226\345\276\252\347\216\257\344\270\255\346\257\217\346\254\241\351\203\275\350\246\201\345\276\200\345\206\205\345\255\230\344\270\255\345\206\231\346\225\260\346\215\256\357\274\232combine4"


.subsections_via_symbols
