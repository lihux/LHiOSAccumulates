	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.section	__TEXT,__literal8,8byte_literals
	.p2align	3
LCPI0_0:
	.quad	4610785298501913805     ## double 1.8
LCPI0_1:
	.quad	4629700416936869888     ## double 32
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_cel2fahr
	.p2align	4, 0x90
_cel2fahr:                              ## @cel2fahr
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
	mulsd	LCPI0_0(%rip), %xmm0
	addsd	LCPI0_1(%rip), %xmm0
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
