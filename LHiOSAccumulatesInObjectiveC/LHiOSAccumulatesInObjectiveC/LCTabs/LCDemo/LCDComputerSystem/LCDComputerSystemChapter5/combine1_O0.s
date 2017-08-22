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
	movq	$0, -24(%rbp)
LBB0_1:                                 ## =>This Inner Loop Header: Depth=1
	movq	-24(%rbp), %rax
	movq	-8(%rbp), %rdi
	movq	%rax, -40(%rbp)         ## 8-byte Spill
	callq	_vec_length
	movq	-40(%rbp), %rdi         ## 8-byte Reload
	cmpq	%rax, %rdi
	jge	LBB0_4
## BB#2:                                ##   in Loop: Header=BB0_1 Depth=1
	leaq	-32(%rbp), %rdx
	movq	-8(%rbp), %rdi
	movq	-24(%rbp), %rsi
	callq	_get_vec_element
	movq	-16(%rbp), %rdx
	movq	(%rdx), %rdx
	imulq	-32(%rbp), %rdx
	movq	-16(%rbp), %rsi
	movq	%rdx, (%rsi)
	movl	%eax, -44(%rbp)         ## 4-byte Spill
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
	.asciz	"\346\234\252\347\273\217\344\273\273\344\275\225\344\274\230\345\214\226\347\232\204combine1"


.subsections_via_symbols
