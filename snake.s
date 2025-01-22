# vi: set ts=2 sw=2 et ft=asm:

.section .data

headl:     .string "O"
bodyl:     .string "o"
SNAKE_LABEL:	.string "[Snake %d,%d]"

.extern pos_x, pos_y, body, score

.section .text

.global render_snake

render_snake:
  pushq %rbp
  movq %rsp, %rbp

  subq $16, %rsp
  movq $0, -8(%rbp)

  mov pos_x(%rip), %esi
  mov pos_y(%rip), %edi
  leaq headl(%rip), %rdx
  call mvprintw

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
  jl .render_snake_end

  movq -8(%rbp), %rax
  movl body(,%rax,8), %esi
  movl body+4(,%rax,8), %edi
  leaq bodyl(%rip), %rdx
  call mvprintw

  movq -8(%rbp), %rax
  addq $1, %rax
  movq %rax, -8(%rbp)
  jmp .render_snake_loop

.render_snake_end:
  leave
  ret
