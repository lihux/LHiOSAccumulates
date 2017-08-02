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
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
	movl	%edx, -12(%rbp)
	movl	%ecx, -16(%rbp)
	movl	%r8d, -20(%rbp)
	movl	%r9d, -24(%rbp)
	movss	%xmm0, -28(%rbp)
	movsd	%xmm1, -40(%rbp)
	movl	-4(%rbp), %ecx
	addl	-8(%rbp), %ecx
	addl	-12(%rbp), %ecx
	addl	-16(%rbp), %ecx
	addl	-20(%rbp), %ecx
	addl	-24(%rbp), %ecx
	cvtsi2ssl	%ecx, %xmm0
	addss	-28(%rbp), %xmm0
	cvtss2sd	%xmm0, %xmm0
	addsd	-40(%rbp), %xmm0
	movsd	%xmm0, -48(%rbp)
	movsd	-48(%rbp), %xmm0        ## xmm0 = mem[0],zero
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
