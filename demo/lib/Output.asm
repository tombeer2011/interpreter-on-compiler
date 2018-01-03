.section .text
	.global Output_printString
Output_printString:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $12, %esp
	pushl $0
	leal -20(%ebp), %ecx
	popl (%ecx)
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $1
	call String_length
	addl $4, %esp
	leal -12(%ebp), %ecx
	popl (%ecx)
.Output_printString_WHILE_START0:
	leal -20(%ebp), %ecx
	pushl (%ecx)
	leal -12(%ebp), %ecx
	pushl (%ecx)
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	jl .LOutput_lt_True_1
	pushl $0
	jmp .LOutput_lt_Continue_1
.LOutput_lt_True_1:
	pushl $-1
.LOutput_lt_Continue_1:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Output_printString_WHILE_OVER0
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	leal -20(%ebp), %ecx
	pushl (%ecx)
	pushl $2
	call String_charAt
	addl $8, %esp
	leal -16(%ebp), %ecx
	popl (%ecx)
	leal -16(%ebp), %ecx
	pushl (%ecx)
	call putchar
	popl -16(%ebx)
	leal -20(%ebp), %ecx
	pushl (%ecx)
	pushl $1
	popl %ecx
	addl %ecx, (%esp)
	leal -20(%ebp), %ecx
	popl (%ecx)
	jmp .Output_printString_WHILE_START0
.Output_printString_WHILE_OVER0:
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
	.global Output_printInt
Output_printInt:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $4, %esp
	pushl $12
	pushl $1
	call String_new
	addl $4, %esp
	leal -12(%ebp), %ecx
	popl (%ecx)
	leal -12(%ebp), %ecx
	pushl (%ecx)
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $2
	call String_setInt
	addl $8, %esp
	popl -16(%ebx)
	leal -12(%ebp), %ecx
	pushl (%ecx)
	pushl $1
	call Output_printString
	addl $4, %esp
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
