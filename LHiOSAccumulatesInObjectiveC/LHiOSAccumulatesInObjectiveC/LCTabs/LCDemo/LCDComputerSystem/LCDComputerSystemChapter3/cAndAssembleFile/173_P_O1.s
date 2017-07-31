	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_P
	.p2align	4, 0x90
_P:                                     ## @P
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
	pushq	%r14
	pushq	%rbx
Ltmp3:
	.cfi_offset %rbx, -32
Ltmp4:
	.cfi_offset %r14, -24
	movq	%rdi, %rbx
	movq	%rsi, %rdi
	callq	_Q
	movq	%rax, %r14
	movq	%rbx, %rdi
	callq	_Q
	addq	%r14, %rax
	popq	%rbx
	popq	%r14
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
