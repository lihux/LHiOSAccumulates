	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_movLL
	.p2align	4, 0x90
_movLL:                                 ## @movLL
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
	movq	(%rdi), %rax
	movq	%rax, (%rsi)
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_movCI
	.p2align	4, 0x90
_movCI:                                 ## @movCI
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
	movsbl	(%rdi), %eax
	movl	%eax, (%rsi)
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_movCU
	.p2align	4, 0x90
_movCU:                                 ## @movCU
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
	movsbl	(%rdi), %eax
	movl	%eax, (%rsi)
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_movUCL
	.p2align	4, 0x90
_movUCL:                                ## @movUCL
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
	movzbl	(%rdi), %eax
	movq	%rax, (%rsi)
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_movIC
	.p2align	4, 0x90
_movIC:                                 ## @movIC
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
	movb	(%rdi), %al
	movb	%al, (%rsi)
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_movUUC
	.p2align	4, 0x90
_movUUC:                                ## @movUUC
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
	movb	(%rdi), %al
	movb	%al, (%rsi)
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_movCS
	.p2align	4, 0x90
_movCS:                                 ## @movCS
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
	movsbl	(%rdi), %eax
	movw	%ax, (%rsi)
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
