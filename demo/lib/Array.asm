.section .text
	.global Array_new
Array_new:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $4, %esp
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	sall $2, (%esp)
	call malloc
	movl %eax, (%esp)
	leal -12(%ebp), %ecx
	popl (%ecx)
	leal -12(%ebp), %ecx
	pushl (%ecx)
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	popl (%ecx)
	movl -4(%ebp), %ecx
	movl %ecx, (%ebx)
	movl -8(%ebp), %ecx
	movl %ecx, -4(%ebx)
	leave
	ret
	.cfi_endproc
	.global Array_dispose
Array_dispose:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $0, %esp
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	popl (%ebx)
	pushl (%ebx)
	call free
	popl -16(%ebx)
	pushl $0
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	popl (%ecx)
	movl -4(%ebp), %ecx
	movl %ecx, (%ebx)
	movl -8(%ebp), %ecx
	movl %ecx, -4(%ebx)
	leave
	ret
	.cfi_endproc
.section .data
