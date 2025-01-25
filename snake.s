# vi: set ts=2 sw=2 et ft=asm:

.section .data

headl:     .string "O"
bodyl:     .string "o"
SNAKE_LABEL:	.string "[Snake %d,%d]"
BODY_LABEL:	.string "[%d,%d]"

.extern pos_x, pos_y, body, score

.section .text

.global render_snake, snake_tick, snake_collision

render_snake:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp
  movl $0, -4(%rbp)
  jmp .render_snake_cond

.render_snake_loop:
  movl -4(%rbp), %eax
  cltq
  movl body(,%rax,8), %ecx
  movl -4(%rbp), %eax
  cltq
  movl  body+4(,%rax,8), %eax
  movl  $bodyl, %edx
  movl  %ecx, %esi
  movl  %eax, %edi
  movl  $0, %eax
  call  mvprintw
  addl  $1, -4(%rbp)

.render_snake_cond:
  movl score(%rip), %eax
  cmpl %eax, -4(%rbp)
  jl .render_snake_loop

  movl pos_x(%rip), %ecx
  movl pos_y(%rip), %eax
  movl $headl, %edx
  movl %ecx, %esi
  movl %eax, %edi
  movl $0, %eax
  call mvprintw
  movl $0, %eax

  leave
  ret

snake_tick:
  pushq %rbp
  movq %rsp, %rbp

  subq $16, %rsp

  movl score(%rip), %eax
  movl %eax, -4(%rbp)

.snake_tick_loop:
  cmpl $0, -4(%rbp)
  jl .snake_tick_end

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

snake_collision:
  pushq %rbp
  movq %rsp, %rbp
  movl $0, -4(%rbp)
  jmp .snake_collision_cond

.snake_collision_loop:
  movl -4(%rbp), %eax
  cltq
  movl body(,%rax,8), %edx
  movl pos_x(%rip), %eax
  cmpl %eax, %edx
  jne .snake_collision_inc
  movl -4(%rbp), %eax
  cltq
  movl body+4(,%rax,8), %edx
  movl pos_y(%rip), %eax
  cmpl %eax, %edx
  jne .snake_collision_inc
  movl $1, %eax
  jmp .snake_collision_exit

.snake_collision_inc:
  addl $1, -4(%rbp)

.snake_collision_cond:
  movl score(%rip), %eax
  cmpl %eax, -4(%rbp)
  jl .snake_collision_loop
  movl $0, %eax

.snake_collision_exit:
  leave
  ret
