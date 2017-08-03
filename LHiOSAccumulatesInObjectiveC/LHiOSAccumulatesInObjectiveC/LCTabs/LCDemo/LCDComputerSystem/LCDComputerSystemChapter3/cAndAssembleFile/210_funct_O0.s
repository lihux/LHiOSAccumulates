	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_funct
	.p2align	4, 0x90
_funct:                                 ## @funct
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
	movsd	%xmm0, -8(%rbp)
	movss	%xmm1, -12(%rbp)
	movsd	%xmm2, -24(%rbp)
	movl	%edi, -28(%rbp)
	movsd	-8(%rbp), %xmm0         ## xmm0 = mem[0],zero
	cvtss2sd	-12(%rbp), %xmm1
	mulsd	%xmm1, %xmm0
	movsd	-24(%rbp), %xmm1        ## xmm1 = mem[0],zero
	cvtsi2sdl	-28(%rbp), %xmm2
	divsd	%xmm2, %xmm1
	subsd	%xmm1, %xmm0
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
