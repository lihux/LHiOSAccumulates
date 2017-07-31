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
	movq	%r8, -40(%rbp)
	movq	-8(%rbp), %rcx
	movq	-8(%rbp), %rdx
	movl	$0, -52(%rbp)
	movq	$0, -48(%rbp)
	movq	%rcx, -64(%rbp)         ## 8-byte Spill
	movq	%rdx, -72(%rbp)         ## 8-byte Spill
LBB0_1:                                 ## =>This Inner Loop Header: Depth=1
	movq	-48(%rbp), %rax
	cmpq	-8(%rbp), %rax
	jge	LBB0_4
## BB#2:                                ##   in Loop: Header=BB0_1 Depth=1
	movq	-48(%rbp), %rax
	movq	-32(%rbp), %rcx
	movq	-16(%rbp), %rdx
	movq	-64(%rbp), %rsi         ## 8-byte Reload
	imulq	%rsi, %rcx
	shlq	$2, %rcx
	addq	%rcx, %rdx
	movl	(%rdx,%rax,4), %edi
	movq	-40(%rbp), %rax
	movq	-48(%rbp), %rcx
	movq	-24(%rbp), %rdx
	movq	-72(%rbp), %r8          ## 8-byte Reload
	imulq	%r8, %rcx
	shlq	$2, %rcx
	addq	%rcx, %rdx
	imull	(%rdx,%rax,4), %edi
	addl	-52(%rbp), %edi
	movl	%edi, -52(%rbp)
## BB#3:                                ##   in Loop: Header=BB0_1 Depth=1
	movq	-48(%rbp), %rax
	addq	$1, %rax
	movq	%rax, -48(%rbp)
	jmp	LBB0_1
LBB0_4:
	movl	-52(%rbp), %eax
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
