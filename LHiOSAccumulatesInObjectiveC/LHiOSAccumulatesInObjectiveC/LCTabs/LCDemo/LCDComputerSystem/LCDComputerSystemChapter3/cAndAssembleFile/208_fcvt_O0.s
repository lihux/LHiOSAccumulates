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
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	%rcx, -32(%rbp)
	movq	-16(%rbp), %rcx
	movss	(%rcx), %xmm0           ## xmm0 = mem[0],zero,zero,zero
	movss	%xmm0, -36(%rbp)
	movq	-24(%rbp), %rcx
	movsd	(%rcx), %xmm0           ## xmm0 = mem[0],zero
	movsd	%xmm0, -48(%rbp)
	movq	-32(%rbp), %rcx
	movq	(%rcx), %rcx
	movq	%rcx, -56(%rbp)
	cvttsd2si	-48(%rbp), %rcx
	movq	-32(%rbp), %rdx
	movq	%rcx, (%rdx)
	cvtsi2ssl	-4(%rbp), %xmm0
	movq	-16(%rbp), %rcx
	movss	%xmm0, (%rcx)
	cvtsi2sdq	-56(%rbp), %xmm0
	movq	-24(%rbp), %rcx
	movsd	%xmm0, (%rcx)
	cvtss2sd	-36(%rbp), %xmm0
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
