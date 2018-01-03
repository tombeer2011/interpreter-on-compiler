.section .text
	.global Sys_halt
Sys_halt:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $0, %esp
	.cfi_endproc
	.global Sys_error
Sys_error:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $4, %esp
	pushl $3
	pushl $1
	call String_new
	addl $4, %esp
	leal -12(%ebp), %ecx
	popl (%ecx)
	pushl $10
	pushl $1
	call String_new
	addl $4, %esp
	pushl $69
	pushl $2
	call String_appendChar
	addl $8, %esp
	pushl $114
	pushl $2
	call String_appendChar
	addl $8, %esp
	pushl $114
	pushl $2
	call String_appendChar
	addl $8, %esp
	pushl $111
	pushl $2
	call String_appendChar
	addl $8, %esp
	pushl $114
	pushl $2
	call String_appendChar
	addl $8, %esp
	pushl $32
	pushl $2
	call String_appendChar
	addl $8, %esp
	pushl $99
	pushl $2
	call String_appendChar
	addl $8, %esp
	pushl $111
	pushl $2
	call String_appendChar
	addl $8, %esp
	pushl $100
	pushl $2
	call String_appendChar
	addl $8, %esp
	pushl $101
	pushl $2
	call String_appendChar
	addl $8, %esp
	leal -12(%ebp), %ecx
	popl (%ecx)
	leal -12(%ebp), %ecx
	pushl (%ecx)
	pushl $1
	call Output_printString
	addl $4, %esp
	popl -16(%ebx)
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $1
	call Output_printInt
	addl $4, %esp
	popl -16(%ebx)
	pushl $1
	pushl $1
	call String_new
	addl $4, %esp
	pushl $10
	pushl $2
	call String_appendChar
	addl $8, %esp
	pushl $1
	call Output_printString
	addl $4, %esp
	popl -16(%ebx)
	pushl $0
	call Sys_halt
	addl $0, %esp
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
