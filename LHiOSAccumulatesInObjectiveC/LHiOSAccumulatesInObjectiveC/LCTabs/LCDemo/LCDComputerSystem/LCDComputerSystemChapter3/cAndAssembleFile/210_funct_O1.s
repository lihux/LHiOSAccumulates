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
	cvtss2sd	%xmm1, %xmm1
	mulsd	%xmm1, %xmm0
	xorps	%xmm1, %xmm1
	cvtsi2sdl	%edi, %xmm1
	divsd	%xmm1, %xmm2
	subsd	%xmm2, %xmm0
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
