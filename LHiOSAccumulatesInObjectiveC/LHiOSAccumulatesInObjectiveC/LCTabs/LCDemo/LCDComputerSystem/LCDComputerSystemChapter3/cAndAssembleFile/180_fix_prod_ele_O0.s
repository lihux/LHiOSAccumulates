	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_fix_prod_ele
	.p2align	4, 0x90
_fix_prod_ele:                          ## @fix_prod_ele
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
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	%rcx, -32(%rbp)
	movl	$0, -44(%rbp)
	movq	$0, -40(%rbp)
LBB0_1:                                 ## =>This Inner Loop Header: Depth=1
	cmpq	$16, -40(%rbp)
	jge	LBB0_4
## BB#2:                                ##   in Loop: Header=BB0_1 Depth=1
	movq	-40(%rbp), %rax
	movq	-24(%rbp), %rcx
	shlq	$6, %rcx
	addq	-8(%rbp), %rcx
	movl	(%rcx,%rax,4), %edx
	movq	-32(%rbp), %rax
	movq	-40(%rbp), %rcx
	shlq	$6, %rcx
	addq	-16(%rbp), %rcx
	imull	(%rcx,%rax,4), %edx
	addl	-44(%rbp), %edx
	movl	%edx, -44(%rbp)
## BB#3:                                ##   in Loop: Header=BB0_1 Depth=1
	movq	-40(%rbp), %rax
	addq	$1, %rax
	movq	%rax, -40(%rbp)
	jmp	LBB0_1
LBB0_4:
	movl	-44(%rbp), %eax
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
