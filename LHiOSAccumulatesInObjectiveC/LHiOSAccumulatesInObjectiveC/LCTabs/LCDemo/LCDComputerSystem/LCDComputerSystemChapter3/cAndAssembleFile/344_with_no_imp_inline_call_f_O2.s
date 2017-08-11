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
	movq	_counter(%rip), %rax
	leaq	4(%rax), %rcx
	movq	%rcx, _counter(%rip)
	leaq	6(,%rax,4), %rax
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
	movq	_counter(%rip), %rax
	leaq	1(%rax), %rcx
	movq	%rcx, _counter(%rip)
	shlq	$2, %rax
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_f
	.p2align	4, 0x90
_f:                                     ## @f
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp6:
	.cfi_def_cfa_offset 16
Ltmp7:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp8:
	.cfi_def_cfa_register %rbp
	movq	_counter(%rip), %rax
	leaq	1(%rax), %rcx
	movq	%rcx, _counter(%rip)
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_counter                ## @counter
.zerofill __DATA,__common,_counter,8,3

.subsections_via_symbols
