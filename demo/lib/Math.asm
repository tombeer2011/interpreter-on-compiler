.section .text
	.global Math_abs
Math_abs:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $4, %esp
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $0
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	jl .LMath_lt_True_1
	pushl $0
	jmp .LMath_lt_Continue_1
.LMath_lt_True_1:
	pushl $-1
.LMath_lt_Continue_1:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Math_abs_IF_RIGHT0
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	negl (%esp)
	leal -12(%ebp), %ecx
	popl (%ecx)
	jmp .Math_abs_IF_WRONG0
.Math_abs_IF_RIGHT0:
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	leal -12(%ebp), %ecx
	popl (%ecx)
.Math_abs_IF_WRONG0:
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
	.global Math_logTwo
Math_logTwo:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $8, %esp
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $107374182
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	jg .LMath_lt_True_2
	pushl $0
	jmp .LMath_lt_Continue_2
.LMath_lt_True_2:
	pushl $-1
.LMath_lt_Continue_2:
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $2147483647
	pushl $2
	call Math_lteq
	addl $8, %esp
	pushl $2
	call Math_and
	addl $8, %esp
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Math_logTwo_IF_RIGHT0
	pushl $31
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	popl (%ecx)
	movl -4(%ebp), %ecx
	movl %ecx, (%ebx)
	movl -8(%ebp), %ecx
	movl %ecx, -4(%ebx)
	leave
	ret
.Math_logTwo_IF_RIGHT0:
	pushl $1
	leal -12(%ebp), %ecx
	popl (%ecx)
	pushl $0
	leal -16(%ebp), %ecx
	popl (%ecx)
.Math_logTwo_WHILE_START0:
	leal -12(%ebp), %ecx
	pushl (%ecx)
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	jl .LMath_lt_True_3
	pushl $0
	jmp .LMath_lt_Continue_3
.LMath_lt_True_3:
	pushl $-1
.LMath_lt_Continue_3:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Math_logTwo_WHILE_OVER0
	leal -12(%ebp), %ecx
	pushl (%ecx)
	leal -12(%ebp), %ecx
	pushl (%ecx)
	popl %ecx
	addl %ecx, (%esp)
	leal -12(%ebp), %ecx
	popl (%ecx)
	leal -16(%ebp), %ecx
	pushl (%ecx)
	pushl $1
	popl %ecx
	addl %ecx, (%esp)
	leal -16(%ebp), %ecx
	popl (%ecx)
	jmp .Math_logTwo_WHILE_START0
.Math_logTwo_WHILE_OVER0:
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
	.global Math_power
Math_power:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $8, %esp
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	leal -12(%ebp), %ecx
	popl (%ecx)
	pushl $1
	leal -16(%ebp), %ecx
	popl (%ecx)
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $0
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	je .LMath_lt_True_4
	pushl $0
	jmp .LMath_lt_Continue_4
.LMath_lt_True_4:
	pushl $-1
.LMath_lt_Continue_4:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Math_power_IF_RIGHT0
	pushl $1
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	popl (%ecx)
	movl -4(%ebp), %ecx
	movl %ecx, (%ebx)
	movl -8(%ebp), %ecx
	movl %ecx, -4(%ebx)
	leave
	ret
.Math_power_IF_RIGHT0:
.Math_power_WHILE_START0:
	leal -12(%ebp), %ecx
	pushl (%ecx)
	pushl $0
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	jg .LMath_lt_True_5
	pushl $0
	jmp .LMath_lt_Continue_5
.LMath_lt_True_5:
	pushl $-1
.LMath_lt_Continue_5:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Math_power_WHILE_OVER0
	leal -16(%ebp), %ecx
	pushl (%ecx)
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	popl %ecx
	popl %edx
	imull %ecx, %edx
	pushl %edx
	leal -16(%ebp), %ecx
	popl (%ecx)
	leal -12(%ebp), %ecx
	pushl (%ecx)
	pushl $1
	popl %ecx
	subl %ecx, (%esp)
	leal -12(%ebp), %ecx
	popl (%ecx)
	jmp .Math_power_WHILE_START0
.Math_power_WHILE_OVER0:
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
	.global Math_max
Math_max:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $0, %esp
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	jg .LMath_lt_True_6
	pushl $0
	jmp .LMath_lt_Continue_6
.LMath_lt_True_6:
	pushl $-1
.LMath_lt_Continue_6:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Math_max_IF_RIGHT0
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
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
	jmp .Math_max_IF_WRONG0
.Math_max_IF_RIGHT0:
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
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
.Math_max_IF_WRONG0:
	.cfi_endproc
	.global Math_min
Math_min:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $0, %esp
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	jl .LMath_lt_True_7
	pushl $0
	jmp .LMath_lt_Continue_7
.LMath_lt_True_7:
	pushl $-1
.LMath_lt_Continue_7:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Math_min_IF_RIGHT0
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
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
	jmp .Math_min_IF_WRONG0
.Math_min_IF_RIGHT0:
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
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
.Math_min_IF_WRONG0:
	.cfi_endproc
	.global Math_or
Math_or:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $0, %esp
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $0
	pushl $2
	call Math_noteq
	addl $8, %esp
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Math_or_IF_RIGHT0
	pushl $1
	negl (%esp)
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	popl (%ecx)
.Math_or_IF_RIGHT0:
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $0
	pushl $2
	call Math_noteq
	addl $8, %esp
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Math_or_IF_RIGHT1
	pushl $1
	negl (%esp)
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	popl (%ecx)
.Math_or_IF_RIGHT1:
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Math_or_IF_RIGHT2
	pushl $1
	negl (%esp)
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	popl (%ecx)
	movl -4(%ebp), %ecx
	movl %ecx, (%ebx)
	movl -8(%ebp), %ecx
	movl %ecx, -4(%ebx)
	leave
	ret
.Math_or_IF_RIGHT2:
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Math_or_IF_RIGHT3
	pushl $1
	negl (%esp)
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	popl (%ecx)
	movl -4(%ebp), %ecx
	movl %ecx, (%ebx)
	movl -8(%ebp), %ecx
	movl %ecx, -4(%ebx)
	leave
	ret
.Math_or_IF_RIGHT3:
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
	.global Math_and
Math_and:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $0, %esp
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $0
	pushl $2
	call Math_noteq
	addl $8, %esp
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Math_and_IF_RIGHT0
	pushl $1
	negl (%esp)
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	popl (%ecx)
.Math_and_IF_RIGHT0:
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $0
	pushl $2
	call Math_noteq
	addl $8, %esp
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Math_and_IF_RIGHT1
	pushl $1
	negl (%esp)
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	popl (%ecx)
.Math_and_IF_RIGHT1:
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $0
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	je .LMath_lt_True_8
	pushl $0
	jmp .LMath_lt_Continue_8
.LMath_lt_True_8:
	pushl $-1
.LMath_lt_Continue_8:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Math_and_IF_RIGHT2
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
.Math_and_IF_RIGHT2:
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $0
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	je .LMath_lt_True_9
	pushl $0
	jmp .LMath_lt_Continue_9
.LMath_lt_True_9:
	pushl $-1
.LMath_lt_Continue_9:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Math_and_IF_RIGHT3
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
.Math_and_IF_RIGHT3:
	pushl $1
	negl (%esp)
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
	.global Math_not
Math_not:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $0, %esp
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $0
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	je .LMath_lt_True_10
	pushl $0
	jmp .LMath_lt_Continue_10
.LMath_lt_True_10:
	pushl $-1
.LMath_lt_Continue_10:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Math_not_IF_RIGHT0
	pushl $1
	negl (%esp)
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	popl (%ecx)
	movl -4(%ebp), %ecx
	movl %ecx, (%ebx)
	movl -8(%ebp), %ecx
	movl %ecx, -4(%ebx)
	leave
	ret
	jmp .Math_not_IF_WRONG0
.Math_not_IF_RIGHT0:
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
.Math_not_IF_WRONG0:
	.cfi_endproc
	.global Math_noteq
Math_noteq:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $0, %esp
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	je .LMath_lt_True_11
	pushl $0
	jmp .LMath_lt_Continue_11
.LMath_lt_True_11:
	pushl $-1
.LMath_lt_Continue_11:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Math_noteq_IF_RIGHT0
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
.Math_noteq_IF_RIGHT0:
	pushl $1
	negl (%esp)
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
	.global Math_lteq
Math_lteq:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $0, %esp
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	je .LMath_lt_True_12
	pushl $0
	jmp .LMath_lt_Continue_12
.LMath_lt_True_12:
	pushl $-1
.LMath_lt_Continue_12:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Math_lteq_IF_RIGHT0
	pushl $1
	negl (%esp)
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	popl (%ecx)
	movl -4(%ebp), %ecx
	movl %ecx, (%ebx)
	movl -8(%ebp), %ecx
	movl %ecx, -4(%ebx)
	leave
	ret
.Math_lteq_IF_RIGHT0:
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	jl .LMath_lt_True_13
	pushl $0
	jmp .LMath_lt_Continue_13
.LMath_lt_True_13:
	pushl $-1
.LMath_lt_Continue_13:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Math_lteq_IF_RIGHT1
	pushl $1
	negl (%esp)
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	popl (%ecx)
	movl -4(%ebp), %ecx
	movl %ecx, (%ebx)
	movl -8(%ebp), %ecx
	movl %ecx, -4(%ebx)
	leave
	ret
.Math_lteq_IF_RIGHT1:
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
	.global Math_gteq
Math_gteq:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $0, %esp
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	je .LMath_lt_True_14
	pushl $0
	jmp .LMath_lt_Continue_14
.LMath_lt_True_14:
	pushl $-1
.LMath_lt_Continue_14:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Math_gteq_IF_RIGHT0
	pushl $1
	negl (%esp)
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	popl (%ecx)
	movl -4(%ebp), %ecx
	movl %ecx, (%ebx)
	movl -8(%ebp), %ecx
	movl %ecx, -4(%ebx)
	leave
	ret
.Math_gteq_IF_RIGHT0:
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	jg .LMath_lt_True_15
	pushl $0
	jmp .LMath_lt_Continue_15
.LMath_lt_True_15:
	pushl $-1
.LMath_lt_Continue_15:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Math_gteq_IF_RIGHT1
	pushl $1
	negl (%esp)
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	popl (%ecx)
	movl -4(%ebp), %ecx
	movl %ecx, (%ebx)
	movl -8(%ebp), %ecx
	movl %ecx, -4(%ebx)
	leave
	ret
.Math_gteq_IF_RIGHT1:
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
	.global Math_mod
Math_mod:
	.cfi_startproc
	pushl %ebp
	movl %esp, %ebp
	pushl (%ebx)
	pushl -4(%ebx)
	subl $16, %esp
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $1
	call Math_abs
	addl $4, %esp
	leal -12(%ebp), %ecx
	popl (%ecx)
	movl 8(%ebp), %ecx
	leal 4(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $1
	call Math_abs
	addl $4, %esp
	leal -16(%ebp), %ecx
	popl (%ecx)
	leal -12(%ebp), %ecx
	pushl (%ecx)
	leal -16(%ebp), %ecx
	pushl (%ecx)
	popl %ecx
	popl %eax
	cltd
	idivl %ecx
	pushl %eax
	leal -20(%ebp), %ecx
	popl (%ecx)
	leal -12(%ebp), %ecx
	pushl (%ecx)
	leal -20(%ebp), %ecx
	pushl (%ecx)
	leal -16(%ebp), %ecx
	pushl (%ecx)
	popl %ecx
	popl %edx
	imull %ecx, %edx
	pushl %edx
	popl %ecx
	subl %ecx, (%esp)
	leal -24(%ebp), %ecx
	popl (%ecx)
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	pushl (%ecx)
	pushl $0
	popl %edx
	popl %ecx
	cmpl %edx, %ecx
	jl .LMath_lt_True_16
	pushl $0
	jmp .LMath_lt_Continue_16
.LMath_lt_True_16:
	pushl $-1
.LMath_lt_Continue_16:
	notl (%esp)
	movl (%esp), %ecx
	testl %ecx, %ecx
	jne .Math_mod_IF_RIGHT0
	leal -24(%ebp), %ecx
	pushl (%ecx)
	negl (%esp)
	movl 8(%ebp), %ecx
	leal 8(%ebp,%ecx,4), %ecx
	popl (%ecx)
	movl -4(%ebp), %ecx
	movl %ecx, (%ebx)
	movl -8(%ebp), %ecx
	movl %ecx, -4(%ebx)
	leave
	ret
.Math_mod_IF_RIGHT0:
	leal -24(%ebp), %ecx
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
.section .data
