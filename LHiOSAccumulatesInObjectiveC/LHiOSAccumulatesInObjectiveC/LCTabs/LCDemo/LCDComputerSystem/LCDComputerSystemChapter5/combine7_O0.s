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
	movq	-40(%rbp), %rax
	subq	$1, %rax
	movq	%rax, -48(%rbp)
	movq	-8(%rbp), %rdi
	callq	_get_vec_start
	movq	%rax, -56(%rbp)
	movq	$0, -24(%rbp)
LBB0_1:                                 ## =>This Inner Loop Header: Depth=1
	movq	-24(%rbp), %rax
	cmpq	-48(%rbp), %rax
	jge	LBB0_4
## BB#2:                                ##   in Loop: Header=BB0_1 Depth=1
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rcx
	movq	-56(%rbp), %rdx
	imulq	(%rdx,%rcx,8), %rax
	movq	-24(%rbp), %rcx
	movq	-56(%rbp), %rdx
	imulq	8(%rdx,%rcx,8), %rax
	movq	%rax, -32(%rbp)
## BB#3:                                ##   in Loop: Header=BB0_1 Depth=1
	movq	-24(%rbp), %rax
	addq	$2, %rax
	movq	%rax, -24(%rbp)
	jmp	LBB0_1
LBB0_4:
	jmp	LBB0_5
LBB0_5:                                 ## =>This Inner Loop Header: Depth=1
	movq	-24(%rbp), %rax
	cmpq	-40(%rbp), %rax
	jge	LBB0_8
## BB#6:                                ##   in Loop: Header=BB0_5 Depth=1
	movq	-32(%rbp), %rax
	movq	-24(%rbp), %rcx
	movq	-56(%rbp), %rdx
	imulq	(%rdx,%rcx,8), %rax
	movq	%rax, -32(%rbp)
## BB#7:                                ##   in Loop: Header=BB0_5 Depth=1
	movq	-24(%rbp), %rax
	addq	$1, %rax
	movq	%rax, -24(%rbp)
	jmp	LBB0_5
LBB0_8:
	movq	-32(%rbp), %rax
	movq	-16(%rbp), %rcx
	movq	%rax, (%rcx)
	addq	$64, %rsp
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
