.section .text
	.global Keyboard_readLine
Keyboard_readLine:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $8, %esp
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $1
	call Output_printString
	addl $4, %esp
	popl -16(%ebx)
	pushl $100
	pushl $1
	call String_new
	addl $4, %esp
	leal -12(%ebp), %ecx
	popl (%ecx)
.Keyboard_readLine_WHILE_START0:
	pushl $1
	negl (%esp)
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Keyboard_readLine_WHILE_OVER0
	call getchar
	pushl %eax
	call putchar
	leal -16(%ebp), %ecx
	popl (%ecx)
	leal -16(%ebp), %ecx
	pushl (%ecx)
	pushl $10
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	je .LKeyboard_lt_True_1
	pushl $0
	jmp .LKeyboard_lt_Continue_1
.LKeyboard_lt_True_1:
	pushl $-1
.LKeyboard_lt_Continue_1:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Keyboard_readLine_IF_RIGHT0
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
	jmp .Keyboard_readLine_IF_WRONG0
.Keyboard_readLine_IF_RIGHT0:
	leal -12(%ebp), %ecx
	pushl (%ecx)
	leal -16(%ebp), %ecx
	pushl (%ecx)
	pushl $2
	call String_appendChar
	addl $8, %esp
	leal -12(%ebp), %ecx
	popl (%ecx)
.Keyboard_readLine_IF_WRONG0:
	jmp .Keyboard_readLine_WHILE_START0
.Keyboard_readLine_WHILE_OVER0:
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
	.global Keyboard_readInt
Keyboard_readInt:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $4, %esp
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $1
	call Keyboard_readLine
	addl $4, %esp
	leal -12(%ebp), %ecx
	popl (%ecx)
	leal -12(%ebp), %ecx
	pushl (%ecx)
	pushl $1
	call String_intValue
	addl $4, %esp
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
