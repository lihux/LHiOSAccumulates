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
	xorl	%eax, %eax
	testq	%rdi, %rdi
	jle	LBB0_3
## BB#1:
	imulq	%rdi, %rcx
	leaq	(%rsi,%rcx,4), %rcx
	leaq	(%rdx,%r8,4), %rdx
	xorl	%eax, %eax
	leaq	(,%rdi,4), %r8
	.p2align	4, 0x90
LBB0_2:                                 ## =>This Inner Loop Header: Depth=1
	movl	(%rdx), %esi
	imull	(%rcx), %esi
	addl	%esi, %eax
	addq	$4, %rcx
	addq	%r8, %rdx
	decq	%rdi
	jne	LBB0_2
LBB0_3:
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
