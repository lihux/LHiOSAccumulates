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
	pushq	%r12
	pushq	%rbx
Ltmp3:
	.cfi_offset %rbx, -48
Ltmp4:
	.cfi_offset %r12, -40
Ltmp5:
	.cfi_offset %r14, -32
Ltmp6:
	.cfi_offset %r15, -24
	movq	%rsi, %r14
	movq	%rdi, %r15
	callq	_vec_length
	movq	%rax, %rbx
	leaq	-1(%rbx), %r12
	movq	%r15, %rdi
	callq	_get_vec_start
	cmpq	$2, %rbx
	jl	LBB0_1
## BB#2:
	leaq	-2(%rbx), %rcx
	movq	%rcx, %rdi
	shrq	%rdi
	btq	$1, %rcx
	jb	LBB0_3
## BB#4:
	movq	8(%rax), %rcx
	imulq	(%rax), %rcx
	movl	$2, %esi
	movq	%rcx, %rdx
	jmp	LBB0_5
LBB0_1:
	xorl	%esi, %esi
	movl	$1, %edx
	movl	$1, %ecx
	jmp	LBB0_9
LBB0_3:
	movl	$1, %ecx
	xorl	%esi, %esi
                                        ## implicit-def: %RDX
LBB0_5:
	testq	%rdi, %rdi
	je	LBB0_8
## BB#6:
	movq	%rcx, %rdx
	.p2align	4, 0x90
LBB0_7:                                 ## =>This Inner Loop Header: Depth=1
	movq	8(%rax,%rsi,8), %rdi
	imulq	(%rax,%rsi,8), %rdi
	imulq	%rdi, %rcx
	imulq	%rdx, %rdi
	movq	24(%rax,%rsi,8), %rdx
	imulq	16(%rax,%rsi,8), %rdx
	imulq	%rdx, %rcx
	imulq	%rdi, %rdx
	addq	$4, %rsi
	cmpq	%r12, %rsi
	jl	LBB0_7
LBB0_8:
	movq	%rbx, %rsi
	andq	$-2, %rsi
LBB0_9:
	cmpq	%rsi, %rbx
	jle	LBB0_16
## BB#10:
	movl	%ebx, %edi
	subl	%esi, %edi
	subq	%rsi, %r12
	andq	$7, %rdi
	je	LBB0_13
## BB#11:
	negq	%rdi
	.p2align	4, 0x90
LBB0_12:                                ## =>This Inner Loop Header: Depth=1
	imulq	(%rax,%rsi,8), %rcx
	incq	%rsi
	incq	%rdi
	jne	LBB0_12
LBB0_13:
	cmpq	$7, %r12
	jb	LBB0_16
## BB#14:
	subq	%rsi, %rbx
	leaq	56(%rax,%rsi,8), %rax
	.p2align	4, 0x90
LBB0_15:                                ## =>This Inner Loop Header: Depth=1
	imulq	-56(%rax), %rcx
	imulq	-48(%rax), %rcx
	imulq	-40(%rax), %rcx
	imulq	-32(%rax), %rcx
	imulq	-24(%rax), %rcx
	imulq	-16(%rax), %rcx
	imulq	-8(%rax), %rcx
	imulq	(%rax), %rcx
	addq	$64, %rax
	addq	$-8, %rbx
	jne	LBB0_15
LBB0_16:
	imulq	%rdx, %rcx
	movq	%rcx, (%r14)
	leaq	L_.str(%rip), %rax
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.cfi_endproc

	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"\344\272\214\346\254\241\345\276\252\347\216\257\345\261\225\345\274\200\357\274\232combine5"


.subsections_via_symbols
