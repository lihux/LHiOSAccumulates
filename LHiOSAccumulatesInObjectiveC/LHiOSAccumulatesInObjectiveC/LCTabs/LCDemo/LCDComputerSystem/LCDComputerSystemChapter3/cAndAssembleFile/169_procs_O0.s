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
	movq	%rdi, -8(%rbp)
	movq	$1, -16(%rbp)
	movq	-8(%rbp), %rdi
	movq	-16(%rbp), %rax
	shlq	$1, %rax
	addq	%rax, %rdi
	movq	%rdi, %rax
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
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movq	-8(%rbp), %rdi
	movslq	-12(%rbp), %rax
	addq	%rax, %rdi
	movq	%rdi, %rax
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
	movw	%dx, %ax
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movw	%ax, -14(%rbp)
	movq	-8(%rbp), %rdi
	movslq	-12(%rbp), %rcx
	addq	%rcx, %rdi
	movswq	-14(%rbp), %rcx
	addq	%rcx, %rdi
	movq	%rdi, %rax
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
	movb	%cl, %al
	movw	%dx, %r8w
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movw	%r8w, -14(%rbp)
	movb	%al, -15(%rbp)
	movq	-8(%rbp), %rdi
	movslq	-12(%rbp), %r9
	addq	%r9, %rdi
	movswl	-14(%rbp), %ecx
	movsbl	-15(%rbp), %edx
	imull	%edx, %ecx
	movslq	%ecx, %r9
	addq	%r9, %rdi
	movq	%rdi, %rax
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
	movb	%cl, %al
	movw	%dx, %r9w
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movw	%r9w, -14(%rbp)
	movb	%al, -15(%rbp)
	movq	%r8, -24(%rbp)
	movq	-8(%rbp), %rdi
	movslq	-12(%rbp), %r8
	addq	%r8, %rdi
	movswq	-14(%rbp), %r8
	addq	%r8, %rdi
	movsbq	-15(%rbp), %r8
	subq	%r8, %rdi
	movq	-24(%rbp), %r8
	movq	%rdi, (%r8)
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
	movb	%cl, %al
	movw	%dx, %r10w
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movw	%r10w, -14(%rbp)
	movb	%al, -15(%rbp)
	movq	%r8, -24(%rbp)
	movq	%r9, -32(%rbp)
	movq	-8(%rbp), %rdi
	movslq	-12(%rbp), %r8
	addq	%r8, %rdi
	movswq	-14(%rbp), %r8
	addq	%r8, %rdi
	movsbq	-15(%rbp), %r8
	subq	%r8, %rdi
	movq	-24(%rbp), %r8
	movq	%rdi, (%r8)
	movq	-24(%rbp), %rdi
	movq	(%rdi), %rdi
	addq	-32(%rbp), %rdi
	movq	%rdi, %rax
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
	movb	%cl, %al
	movw	%dx, %r10w
	movq	16(%rbp), %r11
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movw	%r10w, -14(%rbp)
	movb	%al, -15(%rbp)
	movq	%r8, -24(%rbp)
	movq	%r9, -32(%rbp)
	movq	%r11, -40(%rbp)
	movq	-8(%rbp), %rdi
	movslq	-12(%rbp), %r8
	addq	%r8, %rdi
	movswq	-14(%rbp), %r8
	addq	%r8, %rdi
	movsbq	-15(%rbp), %r8
	subq	%r8, %rdi
	movq	-24(%rbp), %r8
	movq	%rdi, (%r8)
	movq	-24(%rbp), %rdi
	movq	(%rdi), %rdi
	addq	-32(%rbp), %rdi
	addq	-40(%rbp), %rdi
	movq	%rdi, %rax
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
	pushq	%rbx
Ltmp27:
	.cfi_offset %rbx, -24
	movb	%cl, %al
	movw	%dx, %r10w
	movq	24(%rbp), %r11
	movq	16(%rbp), %rbx
	movq	%rdi, -16(%rbp)
	movl	%esi, -20(%rbp)
	movw	%r10w, -22(%rbp)
	movb	%al, -23(%rbp)
	movq	%r8, -32(%rbp)
	movq	%r9, -40(%rbp)
	movq	%rbx, -48(%rbp)
	movq	%r11, -56(%rbp)
	movq	-16(%rbp), %rdi
	movslq	-20(%rbp), %r8
	addq	%r8, %rdi
	movswq	-22(%rbp), %r8
	addq	%r8, %rdi
	movsbq	-23(%rbp), %r8
	subq	%r8, %rdi
	movq	-32(%rbp), %r8
	movq	%rdi, (%r8)
	movq	-32(%rbp), %rdi
	movq	(%rdi), %rdi
	addq	-40(%rbp), %rdi
	movq	-48(%rbp), %r8
	imulq	-56(%rbp), %r8
	addq	%r8, %rdi
	movq	%rdi, %rax
	popq	%rbx
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_proc9
	.p2align	4, 0x90
_proc9:                                 ## @proc9
	.cfi_startproc
## BB#0:
	pushq	%rbp
Ltmp28:
	.cfi_def_cfa_offset 16
Ltmp29:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Ltmp30:
	.cfi_def_cfa_register %rbp
	pushq	%r14
	pushq	%rbx
Ltmp31:
	.cfi_offset %rbx, -32
Ltmp32:
	.cfi_offset %r14, -24
	movb	%cl, %al
	movw	%dx, %r10w
	movq	32(%rbp), %r11
	movq	24(%rbp), %rbx
	movq	16(%rbp), %r14
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movw	%r10w, -30(%rbp)
	movb	%al, -31(%rbp)
	movq	%r8, -40(%rbp)
	movq	%r9, -48(%rbp)
	movq	%r14, -56(%rbp)
	movq	%rbx, -64(%rbp)
	movq	%r11, -72(%rbp)
	movq	-24(%rbp), %rdi
	movslq	-28(%rbp), %r8
	addq	%r8, %rdi
	movswq	-30(%rbp), %r8
	addq	%r8, %rdi
	movsbq	-31(%rbp), %r8
	subq	%r8, %rdi
	movq	-40(%rbp), %r8
	movq	%rdi, (%r8)
	movq	-48(%rbp), %rdi
	imulq	-56(%rbp), %rdi
	imulq	-64(%rbp), %rdi
	movq	-72(%rbp), %r8
	movq	%rdi, (%r8)
	popq	%rbx
	popq	%r14
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
