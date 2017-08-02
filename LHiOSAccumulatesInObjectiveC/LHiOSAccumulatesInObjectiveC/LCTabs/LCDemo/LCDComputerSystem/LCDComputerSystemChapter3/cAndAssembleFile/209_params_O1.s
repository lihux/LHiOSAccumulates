	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_params
	.p2align	4, 0x90
_params:                                ## @params
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
	addl	%esi, %edi
	addl	%edx, %edi
	addl	%ecx, %edi
	addl	%r8d, %edi
	addl	%r9d, %edi
	cvtsi2ssl	%edi, %xmm2
	addss	%xmm0, %xmm2
	xorps	%xmm0, %xmm0
	cvtss2sd	%xmm2, %xmm0
	addsd	%xmm1, %xmm0
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
