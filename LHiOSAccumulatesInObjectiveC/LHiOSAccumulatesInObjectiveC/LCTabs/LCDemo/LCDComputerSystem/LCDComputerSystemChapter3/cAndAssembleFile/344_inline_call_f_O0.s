	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_func1
	.p2align	4, 0x90
_func1:                                 ## @func1
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
	subq	$32, %rsp
	callq	_f
	movq	%rax, -8(%rbp)          ## 8-byte Spill
	callq	_f
	movq	-8(%rbp), %rcx          ## 8-byte Reload
	addq	%rax, %rcx
	movq	%rcx, -16(%rbp)         ## 8-byte Spill
	callq	_f
	movq	-16(%rbp), %rcx         ## 8-byte Reload
	addq	%rax, %rcx
	movq	%rcx, -24(%rbp)         ## 8-byte Spill
	callq	_f
	movq	-24(%rbp), %rcx         ## 8-byte Reload
	addq	%rax, %rcx
	movq	%rcx, %rax
	addq	$32, %rsp
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_func2
	.p2align	4, 0x90
_func2:                                 ## @func2
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp3:
	.cfi_def_cfa_offset 16
Ltmp4:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp5:
	.cfi_def_cfa_register %rbp
	callq	_f
	shlq	$2, %rax
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_counter                ## @counter
.zerofill __DATA,__common,_counter,8,3

.subsections_via_symbols
