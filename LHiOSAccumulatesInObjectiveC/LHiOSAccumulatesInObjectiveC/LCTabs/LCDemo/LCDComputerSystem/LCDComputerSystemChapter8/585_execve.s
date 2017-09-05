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
	subq	$16, %rsp
	leaq	L_.str(%rip), %rdi
	movl	$0, -4(%rbp)
	movb	$0, %al
	callq	_printf
	leaq	L_.str.1(%rip), %rdi
	xorl	%ecx, %ecx
	movl	%ecx, %edx
	movq	%rdx, %rsi
	movl	%eax, -8(%rbp)          ## 4-byte Spill
	callq	_execve
	leaq	L_.str.2(%rip), %rdi
	movl	%eax, -12(%rbp)         ## 4-byte Spill
	movb	$0, %al
	callq	_printf
	xorl	%ecx, %ecx
	movl	%eax, -16(%rbp)         ## 4-byte Spill
	movl	%ecx, %eax
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc

	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"\344\270\213\351\235\242\345\274\200\345\247\213\350\260\203\347\224\250execuve\346\211\247\350\241\214\345\217\246\345\244\226\344\270\200\344\270\252a.out"

L_.str.1:                               ## @.str.1
	.asciz	"a.out"

L_.str.2:                               ## @.str.2
	.asciz	"\350\277\231\346\256\265\344\273\243\347\240\201\347\273\235\344\270\215\344\274\232\346\211\247\350\241\214"


.subsections_via_symbols
