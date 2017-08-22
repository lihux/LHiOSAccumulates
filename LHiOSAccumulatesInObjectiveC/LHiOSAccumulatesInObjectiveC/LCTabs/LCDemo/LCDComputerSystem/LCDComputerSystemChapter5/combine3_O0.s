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
	subq	$48, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rsi
	movq	$1, (%rsi)
	movq	-8(%rbp), %rdi
	callq	_vec_length
	movq	%rax, -32(%rbp)
	movq	-8(%rbp), %rdi
	callq	_get_vec_start
	movq	%rax, -40(%rbp)
	movq	$0, -24(%rbp)
LBB0_1:                                 ## =>This Inner Loop Header: Depth=1
	movq	-24(%rbp), %rax
	cmpq	-32(%rbp), %rax
	jge	LBB0_4
## BB#2:                                ##   in Loop: Header=BB0_1 Depth=1
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	-24(%rbp), %rcx
	movq	-40(%rbp), %rdx
	imulq	(%rdx,%rcx,8), %rax
	movq	-16(%rbp), %rcx
	movq	%rax, (%rcx)
## BB#3:                                ##   in Loop: Header=BB0_1 Depth=1
	movq	-24(%rbp), %rax
	addq	$1, %rax
	movq	%rax, -24(%rbp)
	jmp	LBB0_1
LBB0_4:
	leaq	L_.str(%rip), %rax
	addq	$48, %rsp
	popq	%rbp
	retq
	.cfi_endproc

	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"\346\266\210\351\231\244for\345\276\252\347\216\257\344\270\255\351\200\232\350\277\207\344\275\277\347\224\250\346\226\271\346\263\225\350\260\203\347\224\250\350\216\267\345\217\226\346\214\207\351\222\210:combine3"


.subsections_via_symbols
