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
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	pushq	%rax
Ltmp3:
	.cfi_offset %rbx, -56
Ltmp4:
	.cfi_offset %r12, -48
Ltmp5:
	.cfi_offset %r13, -40
Ltmp6:
	.cfi_offset %r14, -32
Ltmp7:
	.cfi_offset %r15, -24
	movq	%rsi, %r12
	movq	%rdi, %r14
	movq	$1, (%r12)
	callq	_vec_length
	movq	%rax, %r15
	testq	%r15, %r15
	jle	LBB0_3
## BB#1:
	xorl	%ebx, %ebx
	leaq	-48(%rbp), %r13
	.p2align	4, 0x90
LBB0_2:                                 ## =>This Inner Loop Header: Depth=1
	movq	%r14, %rdi
	movq	%rbx, %rsi
	movq	%r13, %rdx
	callq	_get_vec_element
	movq	-48(%rbp), %rax
	imulq	(%r12), %rax
	movq	%rax, (%r12)
	incq	%rbx
	cmpq	%rbx, %r15
	jne	LBB0_2
LBB0_3:
	leaq	L_.str(%rip), %rax
	addq	$8, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.cfi_endproc

	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"combine2\344\274\230\345\214\226\344\272\206for\345\276\252\347\216\257\344\270\255\344\275\277\347\224\250\347\232\204length,\345\276\252\347\216\257\345\244\226\350\256\241\347\256\227\345\207\272\346\235\245"


.subsections_via_symbols
