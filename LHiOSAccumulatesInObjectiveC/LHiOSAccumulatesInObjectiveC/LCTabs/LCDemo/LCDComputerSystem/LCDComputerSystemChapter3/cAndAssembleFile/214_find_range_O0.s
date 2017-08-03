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
	xorps	%xmm1, %xmm1
	movss	%xmm0, -4(%rbp)
	ucomiss	-4(%rbp), %xmm1
	jbe	LBB0_2
## BB#1:
	movl	$0, -8(%rbp)
	jmp	LBB0_9
LBB0_2:
	xorps	%xmm0, %xmm0
	movss	-4(%rbp), %xmm1         ## xmm1 = mem[0],zero,zero,zero
	ucomiss	%xmm0, %xmm1
	jne	LBB0_4
	jp	LBB0_4
## BB#3:
	movl	$1, -8(%rbp)
	jmp	LBB0_8
LBB0_4:
	xorps	%xmm0, %xmm0
	movss	-4(%rbp), %xmm1         ## xmm1 = mem[0],zero,zero,zero
	ucomiss	%xmm0, %xmm1
	jbe	LBB0_6
## BB#5:
	movl	$2, -8(%rbp)
	jmp	LBB0_7
LBB0_6:
	movl	$3, -8(%rbp)
LBB0_7:
	jmp	LBB0_8
LBB0_8:
	jmp	LBB0_9
LBB0_9:
	movl	-8(%rbp), %eax
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
