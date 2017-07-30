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
	pushq	%r15
	pushq	%r14
	pushq	%rbx
	pushq	%rax
Ltmp3:
	.cfi_offset %rbx, -40
Ltmp4:
	.cfi_offset %r14, -32
Ltmp5:
	.cfi_offset %r15, -24
	xorl	%eax, %eax
	callq	_proc0
	movl	$1, %edi
	callq	_proc1
	movq	%rax, %r14
	movl	$1, %edi
	movl	$2, %esi
	callq	_proc2
	imull	%eax, %r14d
	movl	$1, %edi
	movl	$2, %esi
	movl	$3, %edx
	callq	_proc3
	movq	%rax, %r15
	movl	$1, %edi
	movl	$2, %esi
	movl	$3, %edx
	movl	$4, %ecx
	callq	_proc4
	movq	%rax, %rbx
	imull	%r15d, %ebx
	imull	%r14d, %ebx
	movl	$1, %edi
	movl	$2, %esi
	movl	$3, %edx
	movl	$4, %ecx
	movl	$5, %r8d
	callq	_proc5
	movl	$1, %edi
	movl	$2, %esi
	movl	$3, %edx
	movl	$4, %ecx
	movl	$5, %r8d
	movl	$6, %r9d
	callq	_proc6
	leal	(%rax,%rbx,2), %ebx
	subq	$8, %rsp
	movl	$1, %edi
	movl	$2, %esi
	movl	$3, %edx
	movl	$4, %ecx
	movl	$5, %r8d
	movl	$6, %r9d
	pushq	$7
	callq	_proc7
	addq	$16, %rsp
	movq	%rax, %r14
	addl	%ebx, %r14d
	movl	$1, %edi
	movl	$2, %esi
	movl	$3, %edx
	movl	$4, %ecx
	movl	$5, %r8d
	movl	$6, %r9d
	pushq	$8
	pushq	$7
	callq	_proc8
	addq	$16, %rsp
	movq	%rax, %rbx
	addl	%r14d, %ebx
	subq	$8, %rsp
	movl	$1, %edi
	movl	$2, %esi
	movl	$3, %edx
	movl	$4, %ecx
	movl	$5, %r8d
	movl	$6, %r9d
	pushq	$9
	pushq	$8
	pushq	$7
	callq	_proc9
	addq	$32, %rsp
	movl	%ebx, %eax
	addq	$8, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
