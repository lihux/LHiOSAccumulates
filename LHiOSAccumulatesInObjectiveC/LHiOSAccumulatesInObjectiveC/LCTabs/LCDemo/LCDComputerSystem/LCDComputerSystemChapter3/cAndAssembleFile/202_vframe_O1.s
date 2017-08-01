	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_vframe
	.p2align	4, 0x90
_vframe:                                ## @vframe
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
	subq	$16, %rsp
	movq	%rsp, %r8
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, -8(%rbp)
	movq	%rsp, %r10
	leaq	15(,%rdi,8), %rcx
	andq	$-16, %rcx
	movq	%r10, %r9
	subq	%rcx, %r9
	movq	%r9, %rsp
	negq	%rcx
	leaq	-16(%rbp), %rax
	movq	%rax, (%r10,%rcx)
	movq	$1, -16(%rbp)
	cmpq	$2, %rdi
	jl	LBB0_4
## BB#1:
	movq	-16(%rbp), %rcx
	movl	$1, %eax
	.p2align	4, 0x90
LBB0_2:                                 ## =>This Inner Loop Header: Depth=1
	movq	%rdx, (%r9,%rax,8)
	incq	%rcx
	cmpq	%rdi, %rcx
	movq	%rcx, %rax
	jl	LBB0_2
## BB#3:
	movq	%rcx, -16(%rbp)
LBB0_4:
	movq	(%r9,%rsi,8), %rax
	movq	(%rax), %rax
	movq	%r8, %rsp
	movq	___stack_chk_guard@GOTPCREL(%rip), %rcx
	movq	(%rcx), %rcx
	cmpq	-8(%rbp), %rcx
	jne	LBB0_6
## BB#5:
	movq	%rbp, %rsp
	popq	%rbp
	retq
LBB0_6:
	callq	___stack_chk_fail
	.cfi_endproc


.subsections_via_symbols
