	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_proc0
	.p2align	4, 0x90
_proc0:                                 ## @proc0
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
	movl	$1, %eax
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_proc1
	.p2align	4, 0x90
_proc1:                                 ## @proc1
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
	leaq	2(%rdi), %rax
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_proc2
	.p2align	4, 0x90
_proc2:                                 ## @proc2
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
	movslq	%esi, %rax
	addq	%rdi, %rax
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_proc3
	.p2align	4, 0x90
_proc3:                                 ## @proc3
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp9:
	.cfi_def_cfa_offset 16
Ltmp10:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp11:
	.cfi_def_cfa_register %rbp
	movslq	%esi, %rcx
	addq	%rdi, %rcx
	movslq	%edx, %rax
	addq	%rcx, %rax
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_proc4
	.p2align	4, 0x90
_proc4:                                 ## @proc4
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp12:
	.cfi_def_cfa_offset 16
Ltmp13:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp14:
	.cfi_def_cfa_register %rbp
	movslq	%esi, %rsi
	addq	%rdi, %rsi
	imull	%ecx, %edx
	movslq	%edx, %rax
	addq	%rsi, %rax
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_proc5
	.p2align	4, 0x90
_proc5:                                 ## @proc5
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp15:
	.cfi_def_cfa_offset 16
Ltmp16:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp17:
	.cfi_def_cfa_register %rbp
	movslq	%esi, %rax
	addq	%rdi, %rax
	movslq	%edx, %rdx
	addq	%rax, %rdx
	movslq	%ecx, %rax
	subq	%rax, %rdx
	movq	%rdx, (%r8)
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_proc6
	.p2align	4, 0x90
_proc6:                                 ## @proc6
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp18:
	.cfi_def_cfa_offset 16
Ltmp19:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp20:
	.cfi_def_cfa_register %rbp
	movslq	%esi, %rsi
	addq	%rdi, %rsi
	movslq	%edx, %rax
	addq	%rsi, %rax
	movslq	%ecx, %rcx
	subq	%rcx, %rax
	movq	%rax, (%r8)
	addq	%r9, %rax
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_proc7
	.p2align	4, 0x90
_proc7:                                 ## @proc7
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp21:
	.cfi_def_cfa_offset 16
Ltmp22:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp23:
	.cfi_def_cfa_register %rbp
	movslq	%esi, %rsi
	addq	%rdi, %rsi
	movslq	%edx, %rax
	addq	%rsi, %rax
	movslq	%ecx, %rcx
	subq	%rcx, %rax
	movq	%rax, (%r8)
	addq	%r9, %rax
	addq	16(%rbp), %rax
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_proc8
	.p2align	4, 0x90
_proc8:                                 ## @proc8
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp24:
	.cfi_def_cfa_offset 16
Ltmp25:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp26:
	.cfi_def_cfa_register %rbp
	movq	24(%rbp), %rax
	movslq	%esi, %rsi
	addq	%rdi, %rsi
	movslq	%edx, %rdx
	addq	%rsi, %rdx
	movslq	%ecx, %rcx
	subq	%rcx, %rdx
	movq	%rdx, (%r8)
	addq	%r9, %rdx
	imulq	16(%rbp), %rax
	addq	%rdx, %rax
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_proc9
	.p2align	4, 0x90
_proc9:                                 ## @proc9
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp27:
	.cfi_def_cfa_offset 16
Ltmp28:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp29:
	.cfi_def_cfa_register %rbp
	movq	32(%rbp), %rax
	movslq	%esi, %rsi
	addq	%rdi, %rsi
	movslq	%edx, %rdx
	addq	%rsi, %rdx
	movslq	%ecx, %rcx
	subq	%rcx, %rdx
	movq	%rdx, (%r8)
	imulq	16(%rbp), %r9
	imulq	24(%rbp), %r9
	movq	%r9, (%rax)
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
