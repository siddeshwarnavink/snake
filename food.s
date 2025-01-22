# vi: set ts=2 sw=2 et ft=asm:

.section .data
food:       .string "@"
FOOD_LABLE:	.string "[Food: %d,%d]"

.extern SCREEN_WIDTH, SCREEN_HEIGHT
.extern food_x, food_y, pos_x, pos_y

.section .text

.global spawn_food, render_food, food_collision

render_food:
  pushq %rbp
  movq %rsp, %rbp

  movl food_x(%rip), %esi
  movl food_y(%rip), %edi
  leal food(%rip), %edx
  call mvprintw

  movl $55, %esi
  movl $2, %edi
  leal FOOD_LABLE(%rip), %edx
  movl food_x(%rip), %ecx
  movl food_y(%rip), %eax
  movl %eax, %r8d
  call mvprintw
	
  leave
  ret

spawn_food:
  pushq %rbp
  movq %rsp, %rbp
  subq $8, %rsp

.spawn_food_x:
  xor %rdi, %rdi
  call time
  movl %eax, -8(%rbp)

  movl -8(%rbp), %edi
  call srand

  call rand
  movl %eax, -4(%rbp)

  xor %edx, %edx
  movl SCREEN_HEIGHT(%rip), %eax
  movl %eax, %ecx
  movl -4(%rbp), %eax
  divl %ecx

  cmp %edx, food_x(%rip)
  je .spawn_food_x

  movl %edx, food_x(%rip)

.spawn_food_y:
  movl -8(%rbp), %eax
  addl $69, %eax
  movl %eax, -8(%rbp)

  movl -8(%rbp), %edi
  call srand

  call rand
  movl %eax, -4(%rbp)

  xor %edx, %edx
  movl SCREEN_WIDTH(%rip), %eax
  movl %eax, %ecx
  movl -4(%rbp), %eax
  divl %ecx

  cmp %edx, food_y(%rip)
  je .spawn_food_y

  movl %edx, food_y(%rip)

.spawn_food_done:
  leave
  ret

food_collision:
  pushq %rbp
  movq %rsp, %rbp

  movl pos_x(%rip), %eax
  cmp %eax, food_x(%rip)
  jne .not_colliding

  movl pos_y(%rip), %eax
  cmp %eax, food_y(%rip)
  jne .not_colliding

  movl $1, %eax
  leave
  ret

.not_colliding:
  movl $0, %eax
  leave
  ret
