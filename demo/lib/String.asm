.section .text
	.global String_new
String_new:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $0, %esp
	pushl $3
	sall $2, (%esp)
	call malloc
	movl %eax, (%esp)
	popl (%ebx)
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $1
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	jl .LString_lt_True_1
	pushl $0
	jmp .LString_lt_Continue_1
.LString_lt_True_1:
	pushl $-1
.LString_lt_Continue_1:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .String_new_IF_RIGHT0
	pushl $1
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	popl (%ecx)
.String_new_IF_RIGHT0:
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	movl (%ebx), %ecx
	leal 8(%ecx), %ecx
	popl (%ecx)
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $1
	call Array_new
	addl $4, %esp
	movl (%ebx), %ecx
	leal 0(%ecx), %ecx
	popl (%ecx)
	pushl $0
	movl (%ebx), %ecx
	leal 4(%ecx), %ecx
	popl (%ecx)
	pushl (%ebx)
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
	.global String_length
String_length:
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
	movl (%ebx), %ecx
	leal 4(%ecx), %ecx
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
	.global String_dispose
String_dispose:
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
	movl (%ebx), %ecx
	leal 0(%ecx), %ecx
	pushl (%ecx)
	pushl $1
	call Array_dispose
	addl $4, %esp
	popl -16(%ebx)
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
	.global String_charAt
String_charAt:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $4, %esp
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	popl (%ebx)
	movl (%ebx), %ecx
	leal 0(%ecx), %ecx
	pushl (%ecx)
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $4
	popl %ecx
	popl %edx
	imull %ecx, %edx
	pushl %edx
	popl %ecx
	addl %ecx, (%esp)
	popl -4(%ebx)
	movl -4(%ebx), %ecx
	leal 0(%ecx), %ecx
	pushl (%ecx)
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
	.global String_setCharAt
String_setCharAt:
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
	movl (%ebx), %ecx
	leal 0(%ecx), %ecx
	pushl (%ecx)
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $4
	popl %ecx
	popl %edx
	imull %ecx, %edx
	pushl %edx
	popl %ecx
	addl %ecx, (%esp)
	movl 8(%ebp), %ecx
	leal 0(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	popl -16(%ebx)
	popl -4(%ebx)
	pushl -16(%ebx)
	movl -4(%ebx), %ecx
	leal 0(%ecx), %ecx
	popl (%ecx)
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
	.global String_eraseLastChar
String_eraseLastChar:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $4, %esp
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	popl (%ebx)
	movl (%ebx), %ecx
	leal 4(%ecx), %ecx
	pushl (%ecx)
	leal -12(%ebp), %ecx
	popl (%ecx)
	movl (%ebx), %ecx
	leal 4(%ecx), %ecx
	pushl (%ecx)
	pushl $1
	popl %ecx
	subl %ecx, (%esp)
	movl (%ebx), %ecx
	leal 4(%ecx), %ecx
	popl (%ecx)
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
	.global String_appendChar
String_appendChar:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $4, %esp
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	popl (%ebx)
	movl (%ebx), %ecx
	leal 4(%ecx), %ecx
	pushl (%ecx)
	movl (%ebx), %ecx
	leal 8(%ecx), %ecx
	pushl (%ecx)
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	je .LString_lt_True_2
	pushl $0
	jmp .LString_lt_Continue_2
.LString_lt_True_2:
	pushl $-1
.LString_lt_Continue_2:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .String_appendChar_IF_RIGHT0
	pushl $17
	pushl $1
	call Sys_error
	addl $4, %esp
	popl -16(%ebx)
.String_appendChar_IF_RIGHT0:
	movl (%ebx), %ecx
	leal 4(%ecx), %ecx
	pushl (%ecx)
	leal -12(%ebp), %ecx
	popl (%ecx)
	movl (%ebx), %ecx
	leal 0(%ecx), %ecx
	pushl (%ecx)
	leal -12(%ebp), %ecx
	pushl (%ecx)
	pushl $4
	popl %ecx
	popl %edx
	imull %ecx, %edx
	pushl %edx
	popl %ecx
	addl %ecx, (%esp)
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	popl -16(%ebx)
	popl -4(%ebx)
	pushl -16(%ebx)
	movl -4(%ebx), %ecx
	leal 0(%ecx), %ecx
	popl (%ecx)
	movl (%ebx), %ecx
	leal 4(%ecx), %ecx
	pushl (%ecx)
	pushl $1
	popl %ecx
	addl %ecx, (%esp)
	movl (%ebx), %ecx
	leal 4(%ecx), %ecx
	popl (%ecx)
	pushl (%ebx)
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
	.global String_intValue
String_intValue:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $16, %esp
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	popl (%ebx)
	pushl $0
	leal -24(%ebp), %ecx
	popl (%ecx)
	pushl $0
	leal -12(%ebp), %ecx
	popl (%ecx)
	pushl $0
	leal -16(%ebp), %ecx
	popl (%ecx)
	movl (%ebx), %ecx
	leal 0(%ecx), %ecx
	pushl (%ecx)
	pushl $0
	pushl $4
	popl %ecx
	popl %edx
	imull %ecx, %edx
	pushl %edx
	popl %ecx
	addl %ecx, (%esp)
	popl -4(%ebx)
	movl -4(%ebx), %ecx
	leal 0(%ecx), %ecx
	pushl (%ecx)
	pushl $45
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	je .LString_lt_True_3
	pushl $0
	jmp .LString_lt_Continue_3
.LString_lt_True_3:
	pushl $-1
.LString_lt_Continue_3:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .String_intValue_IF_RIGHT0
	pushl $1
	negl (%esp)
	leal -24(%ebp), %ecx
	popl (%ecx)
	leal -12(%ebp), %ecx
	pushl (%ecx)
	pushl $1
	popl %ecx
	addl %ecx, (%esp)
	leal -12(%ebp), %ecx
	popl (%ecx)
.String_intValue_IF_RIGHT0:
.String_intValue_WHILE_START0:
	leal -12(%ebp), %ecx
	pushl (%ecx)
	movl (%ebx), %ecx
	leal 4(%ecx), %ecx
	pushl (%ecx)
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	jl .LString_lt_True_4
	pushl $0
	jmp .LString_lt_Continue_4
.LString_lt_True_4:
	pushl $-1
.LString_lt_Continue_4:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .String_intValue_WHILE_OVER0
	movl (%ebx), %ecx
	leal 0(%ecx), %ecx
	pushl (%ecx)
	leal -12(%ebp), %ecx
	pushl (%ecx)
	pushl $4
	popl %ecx
	popl %edx
	imull %ecx, %edx
	pushl %edx
	popl %ecx
	addl %ecx, (%esp)
	popl -4(%ebx)
	movl -4(%ebx), %ecx
	leal 0(%ecx), %ecx
	pushl (%ecx)
	pushl $48
	popl %ecx
	subl %ecx, (%esp)
	leal -20(%ebp), %ecx
	popl (%ecx)
	leal -16(%ebp), %ecx
	pushl (%ecx)
	pushl $10
	popl %ecx
	popl %edx
	imull %ecx, %edx
	pushl %edx
	leal -20(%ebp), %ecx
	pushl (%ecx)
	popl %ecx
	addl %ecx, (%esp)
	leal -16(%ebp), %ecx
	popl (%ecx)
	leal -12(%ebp), %ecx
	pushl (%ecx)
	pushl $1
	popl %ecx
	addl %ecx, (%esp)
	leal -12(%ebp), %ecx
	popl (%ecx)
	jmp .String_intValue_WHILE_START0
.String_intValue_WHILE_OVER0:
	leal -24(%ebp), %ecx
	pushl (%ecx)
	pushl $1
	negl (%esp)
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	je .LString_lt_True_5
	pushl $0
	jmp .LString_lt_Continue_5
.LString_lt_True_5:
	pushl $-1
.LString_lt_Continue_5:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .String_intValue_IF_RIGHT1
	leal -16(%ebp), %ecx
	pushl (%ecx)
	negl (%esp)
	leal -16(%ebp), %ecx
	popl (%ecx)
.String_intValue_IF_RIGHT1:
	leal -16(%ebp), %ecx
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
	.global String_setInt
String_setInt:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $16, %esp
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	popl (%ebx)
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $0
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	jl .LString_lt_True_6
	pushl $0
	jmp .LString_lt_Continue_6
.LString_lt_True_6:
	pushl $-1
.LString_lt_Continue_6:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .String_setInt_IF_RIGHT0
	pushl (%ebx)
	pushl $45
	pushl $2
	call String_appendChar
	addl $8, %esp
	popl -16(%ebx)
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $1
	call Math_abs
	addl $4, %esp
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	popl (%ecx)
.String_setInt_IF_RIGHT0:
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $10
	popl %ecx
	popl %eax
	cltd
	idivl %ecx
	pushl %eax
	leal -16(%ebp), %ecx
	popl (%ecx)
	leal -16(%ebp), %ecx
	pushl (%ecx)
	pushl $10
	popl %ecx
	popl %edx
	imull %ecx, %edx
	pushl %edx
	leal -20(%ebp), %ecx
	popl (%ecx)
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	leal -20(%ebp), %ecx
	pushl (%ecx)
	popl %ecx
	subl %ecx, (%esp)
	leal -12(%ebp), %ecx
	popl (%ecx)
	leal -12(%ebp), %ecx
	pushl (%ecx)
	pushl $48
	popl %ecx
	addl %ecx, (%esp)
	leal -24(%ebp), %ecx
	popl (%ecx)
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $10
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	jl .LString_lt_True_7
	pushl $0
	jmp .LString_lt_Continue_7
.LString_lt_True_7:
	pushl $-1
.LString_lt_Continue_7:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .String_setInt_IF_RIGHT1
	pushl (%ebx)
	leal -24(%ebp), %ecx
	pushl (%ecx)
	pushl $2
	call String_appendChar
	addl $8, %esp
	popl -16(%ebx)
	jmp .String_setInt_IF_WRONG1
.String_setInt_IF_RIGHT1:
	pushl (%ebx)
	leal -16(%ebp), %ecx
	pushl (%ecx)
	pushl $2
	call String_setInt
	addl $8, %esp
	popl -16(%ebx)
	pushl (%ebx)
	leal -24(%ebp), %ecx
	pushl (%ecx)
	pushl $2
	call String_appendChar
	addl $8, %esp
	popl -16(%ebx)
.String_setInt_IF_WRONG1:
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
