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
	cmpq	$2, %rbx
	jl	LBB0_1
## BB#7:
	leaq	-1(%rbx), %r8
	movl	$1, %ecx
	xorl	%edi, %edi
	movl	$1, %edx
	.p2align	4, 0x90
LBB0_8:                                 ## =>This Inner Loop Header: Depth=1
	movq	8(%rax,%rdi,8), %rsi
	imulq	(%rax,%rdi,8), %rsi
	imulq	%rsi, %rcx
	imulq	%rsi, %rdx
	addq	$2, %rdi
	cmpq	%r8, %rdi
	jl	LBB0_8
## BB#2:
	movq	%rbx, %rsi
	andq	$-2, %rsi
	jmp	LBB0_3
LBB0_1:
	xorl	%esi, %esi
	movl	$1, %edx
	movl	$1, %ecx
LBB0_3:
	cmpq	%rbx, %rsi
	jge	LBB0_6
## BB#4:
	leaq	(%rax,%rsi,8), %rax
	subq	%rsi, %rbx
	.p2align	4, 0x90
LBB0_5:                                 ## =>This Inner Loop Header: Depth=1
	imulq	(%rax), %rcx
	addq	$8, %rax
	decq	%rbx
	jne	LBB0_5
LBB0_6:
	imulq	%rdx, %rcx
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
	.asciz	"\344\272\214\346\254\241\345\276\252\347\216\257\345\261\225\345\274\200\357\274\232combine5"


.subsections_via_symbols
