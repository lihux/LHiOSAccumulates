	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_fix_prod_ele
	.p2align	4, 0x90
_fix_prod_ele:                          ## @fix_prod_ele
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
	shlq	$6, %rdx
	addq	%rdi, %rdx
	leaq	(%rsi,%rcx,4), %rcx
	xorl	%eax, %eax
	xorl	%esi, %esi
	.p2align	4, 0x90
LBB0_1:                                 ## =>This Inner Loop Header: Depth=1
	movl	(%rcx), %edi
	imull	(%rdx,%rsi,4), %edi
	addl	%edi, %eax
	incq	%rsi
	addq	$64, %rcx
	cmpq	$16, %rsi
	jne	LBB0_1
## BB#2:
                                        ## kill: %EAX<def> %EAX<kill> %RAX<kill>
	popq	%rbp
	retq
	.cfi_endproc


.subsections_via_symbols
