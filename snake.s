# vi: set ts=2 sw=2 et ft=asm:

.section .data

headl:     .string "O"
bodyl:     .string "o"
SNAKE_LABEL:	.string "[Snake %d,%d]"
BODY_LABEL:	.string "[%d,%d]"

.extern pos_x, pos_y, body, score

.section .text

.global render_snake, snake_tick

render_snake:
  pushq %rbp
  movq %rsp, %rbp

  subq $16, %rsp
  movq $0, -8(%rbp)

  movl $55, %esi
  movl $1, %edi
  leal SNAKE_LABEL(%rip), %edx
  movl pos_x(%rip), %ecx
  movl pos_y(%rip), %eax
  movl %eax, %r8d
  call mvprintw
	
.render_snake_loop:
  movq -8(%rbp), %rax
  movl score(%rip), %ebx

  cmp %rax, %rbx
  jle .render_snake_end

  movq -8(%rbp), %rax
  movl body(,%rax,4), %esi
  movl body+4(,%rax,4), %edi
  leaq bodyl(%rip), %rdx
  call mvprintw

  movq -8(%rbp), %rax
  movl $55, %esi
  movl $3, %edi
  addl %eax, %edi
  leal BODY_LABEL(%rip), %edx
  movl body(,%rax,4), %ecx
  movl body+4(,%rax,4), %eax
  movl %eax, %r8d
  call mvprintw

  movq -8(%rbp), %rax
  addq $1, %rax
  movq %rax, -8(%rbp)
  jmp .render_snake_loop

.render_snake_end:
  mov pos_x(%rip), %esi
  mov pos_y(%rip), %edi
  leaq headl(%rip), %rdx
  call mvprintw

  leave
  ret

snake_tick:
  pushq %rbp
  movq %rsp, %rbp

  subq $16, %rsp
  
  movl score(%rip), %eax
  movl %eax, -4(%rbp)

.snake_tick_loop:
  cmpl    $0, -4(%rbp)
  je .snake_tick_end

  movl -4(%rbp), %eax
  leal -1(%rax), %edx
  movl -4(%rbp), %eax
  cltq
  movslq %edx, %rdx
  movq body(,%rdx,8), %rdx
  movq %rdx, body(,%rax,8)

  subl $1, -4(%rbp)
  jmp .snake_tick_loop

.snake_tick_end:
  movl pos_x(%rip), %eax
  movl %eax, body(%rip)
  movl pos_y(%rip), %eax
  movl %eax, body+4(%rip)

  leave
  ret
