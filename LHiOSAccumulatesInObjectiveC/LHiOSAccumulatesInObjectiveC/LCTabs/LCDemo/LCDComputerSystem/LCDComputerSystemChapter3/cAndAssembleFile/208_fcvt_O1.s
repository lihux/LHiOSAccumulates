	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_fcvt
	.p2align	4, 0x90
_fcvt:                                  ## @fcvt
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
	cvttsd2si	(%rdx), %rax
	cvtsi2sdq	(%rcx), %xmm0
	movss	(%rsi), %xmm1           ## xmm1 = mem[0],zero,zero,zero
	movq	%rax, (%rcx)
	cvtsi2ssl	%edi, %xmm2
	movss	%xmm2, (%rsi)
	movsd	%xmm0, (%rdx)
	xorps	%xmm0, %xmm0
	cvtss2sd	%xmm1, %xmm0
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
