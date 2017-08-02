	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_float_mov
	.p2align	4, 0x90
_float_mov:                             ## @float_mov
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
	movss	(%rdi), %xmm0           ## xmm0 = mem[0],zero,zero,zero
	movss	%xmm0, (%rsi)
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
