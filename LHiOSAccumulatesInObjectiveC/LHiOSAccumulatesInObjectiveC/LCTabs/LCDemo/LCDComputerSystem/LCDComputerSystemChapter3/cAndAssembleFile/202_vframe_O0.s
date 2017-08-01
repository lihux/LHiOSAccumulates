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
	subq	$64, %rsp
	leaq	-40(%rbp), %rax
	movq	___stack_chk_guard@GOTPCREL(%rip), %rcx
	movq	(%rcx), %rcx
	movq	%rcx, -8(%rbp)
	movq	%rdi, -16(%rbp)
	movq	%rsi, -24(%rbp)
	movq	%rdx, -32(%rbp)
	movq	-16(%rbp), %rcx
	movq	%rsp, %rdx
	movq	%rdx, -48(%rbp)
	leaq	15(,%rcx,8), %rcx
	andq	$-16, %rcx
	movq	%rsp, %rdx
	subq	%rcx, %rdx
	movq	%rdx, %rsp
	movq	%rax, (%rdx)
	movq	$1, -40(%rbp)
	movq	%rdx, -56(%rbp)         ## 8-byte Spill
LBB0_1:                                 ## =>This Inner Loop Header: Depth=1
	movq	-40(%rbp), %rax
	cmpq	-16(%rbp), %rax
	jge	LBB0_4
## BB#2:                                ##   in Loop: Header=BB0_1 Depth=1
	movq	-32(%rbp), %rax
	movq	-40(%rbp), %rcx
	movq	-56(%rbp), %rdx         ## 8-byte Reload
	movq	%rax, (%rdx,%rcx,8)
## BB#3:                                ##   in Loop: Header=BB0_1 Depth=1
	movq	-40(%rbp), %rax
	addq	$1, %rax
	movq	%rax, -40(%rbp)
	jmp	LBB0_1
LBB0_4:
	movq	-24(%rbp), %rax
	movq	-56(%rbp), %rcx         ## 8-byte Reload
	movq	(%rcx,%rax,8), %rax
	movq	(%rax), %rax
	movq	-48(%rbp), %rdx
	movq	%rdx, %rsp
	movq	___stack_chk_guard@GOTPCREL(%rip), %rdx
	movq	(%rdx), %rdx
	movq	-8(%rbp), %rsi
	cmpq	%rsi, %rdx
	movq	%rax, -64(%rbp)         ## 8-byte Spill
	jne	LBB0_6
## BB#5:
	movq	-64(%rbp), %rax         ## 8-byte Reload
	movq	%rbp, %rsp
	popq	%rbp
	retq
LBB0_6:
	callq	___stack_chk_fail
	.cfi_endproc


.subsections_via_symbols
