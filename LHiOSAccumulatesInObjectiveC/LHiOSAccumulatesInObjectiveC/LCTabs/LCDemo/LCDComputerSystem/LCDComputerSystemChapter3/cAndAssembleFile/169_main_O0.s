	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_main
	.p2align	4, 0x90
_main:                                  ## @main
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
	pushq	%r14
	pushq	%rbx
	subq	$112, %rsp
Ltmp3:
	.cfi_offset %rbx, -32
Ltmp4:
	.cfi_offset %r14, -24
	movl	$9, %eax
	movl	%eax, %ecx
	movl	$5, %eax
	movl	%eax, %edx
	movl	$0, -20(%rbp)
	movq	$1, -32(%rbp)
	movl	$2, -36(%rbp)
	movw	$3, -38(%rbp)
	movb	$4, -39(%rbp)
	movq	%rdx, -48(%rbp)
	movq	$6, -56(%rbp)
	movq	$7, -64(%rbp)
	movq	$8, -72(%rbp)
	movq	%rcx, -80(%rbp)
	movl	$0, -84(%rbp)
	movb	$0, %al
	callq	_proc0
	addl	-84(%rbp), %eax
	movl	%eax, -84(%rbp)
	movq	$2, -96(%rbp)
	movq	-32(%rbp), %rdi
	callq	_proc1
	imulq	-96(%rbp), %rax
	movq	%rax, -96(%rbp)
	movq	-32(%rbp), %rdi
	movl	-36(%rbp), %esi
	callq	_proc2
	imulq	-96(%rbp), %rax
	movq	%rax, -96(%rbp)
	movq	-32(%rbp), %rdi
	movl	-36(%rbp), %esi
	movswl	-38(%rbp), %edx
	callq	_proc3
	imulq	-96(%rbp), %rax
	movq	%rax, -96(%rbp)
	movq	-32(%rbp), %rdi
	movl	-36(%rbp), %esi
	movw	-38(%rbp), %r8w
	movswl	%r8w, %edx
	movsbl	-39(%rbp), %ecx
	callq	_proc4
	imulq	-96(%rbp), %rax
	movq	%rax, -96(%rbp)
	movq	-32(%rbp), %rdi
	movl	-36(%rbp), %esi
	movw	-38(%rbp), %r8w
	movb	-39(%rbp), %r9b
	movq	-48(%rbp), %rax
	movswl	%r8w, %edx
	movsbl	%r9b, %ecx
	movq	%rax, %r8
	callq	_proc5
	movq	-32(%rbp), %rdi
	movl	-36(%rbp), %esi
	movw	-38(%rbp), %r10w
	movb	-39(%rbp), %r9b
	movq	-48(%rbp), %r8
	movq	-56(%rbp), %rax
	movswl	%r10w, %edx
	movsbl	%r9b, %ecx
	movq	%rax, %r9
	callq	_proc6
	addq	-96(%rbp), %rax
	movq	%rax, -96(%rbp)
	movq	-32(%rbp), %rdi
	movl	-36(%rbp), %esi
	movw	-38(%rbp), %r10w
	movb	-39(%rbp), %r11b
	movq	-48(%rbp), %r8
	movq	-56(%rbp), %r9
	movq	-64(%rbp), %rax
	movswl	%r10w, %edx
	movsbl	%r11b, %ecx
	movq	%rax, (%rsp)
	callq	_proc7
	addq	-96(%rbp), %rax
	movq	%rax, -96(%rbp)
	movq	-32(%rbp), %rdi
	movl	-36(%rbp), %esi
	movw	-38(%rbp), %r10w
	movb	-39(%rbp), %r11b
	movq	-48(%rbp), %r8
	movq	-56(%rbp), %r9
	movq	-64(%rbp), %rax
	movq	-72(%rbp), %rbx
	movswl	%r10w, %edx
	movsbl	%r11b, %ecx
	movq	%rax, (%rsp)
	movq	%rbx, 8(%rsp)
	callq	_proc8
	addq	-96(%rbp), %rax
	movq	%rax, -96(%rbp)
	movq	-32(%rbp), %rdi
	movl	-36(%rbp), %esi
	movw	-38(%rbp), %r10w
	movb	-39(%rbp), %r11b
	movq	-48(%rbp), %r8
	movq	-56(%rbp), %r9
	movq	-64(%rbp), %rax
	movq	-72(%rbp), %rbx
	movq	-80(%rbp), %r14
	movswl	%r10w, %edx
	movsbl	%r11b, %ecx
	movq	%rax, (%rsp)
	movq	%rbx, 8(%rsp)
	movq	%r14, 16(%rsp)
	callq	_proc9
	movq	-96(%rbp), %rax
	movl	%eax, %ecx
	movl	%ecx, %eax
	addq	$112, %rsp
	popq	%rbx
	popq	%r14
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
