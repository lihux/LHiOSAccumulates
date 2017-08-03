	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_find_range
	.p2align	4, 0x90
_find_range:                            ## @find_range
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
	xorl	%eax, %eax
	xorps	%xmm1, %xmm1
	ucomiss	%xmm0, %xmm1
	ja	LBB0_3
## BB#1:
	movl	$1, %eax
	ucomiss	%xmm1, %xmm0
	jne	LBB0_2
	jnp	LBB0_3
LBB0_2:
	xorps	%xmm1, %xmm1
	xorl	%eax, %eax
	ucomiss	%xmm1, %xmm0
	setbe	%al
	orl	$2, %eax
LBB0_3:
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
