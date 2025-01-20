# vi: set ts=2 sw=2 et ft=asm:

.section .data
food:    .string "@"

.extern SCREEN_WIDTH, SCREEN_HEIGHT
.extern food_x, food_y, pos_x, pos_y

.section .text

.global spawn_food, render_food, food_collision

render_food:
  pushq %rbp
  movq %rsp, %rbp

  movl food_y(%rip), %esi
  movl food_x(%rip), %edi
  leaq food(%rip), %rdx
  call mvprintw

  leave
  ret

spawn_food:
  pushq %rbp
  movq %rsp, %rbp
  subq $4, %rsp

  call srand

  # food_x = rand() % SCREEN_WIDTH

  call rand
  movl %eax, -4(%rbp)

  movl SCREEN_WIDTH(%rip), %eax
  movl %eax, %ecx
  movl -4(%rbp), %eax
  divl %ecx
  movl %edx, food_x(%rip)

  # food_y = rand() % SCREEN_HEIGHT

  call rand
  movl %eax, -4(%rbp)

  movl SCREEN_HEIGHT(%rip), %eax
  movl %eax, %ecx
  movl -4(%rbp), %eax
  divl %ecx
  movl %edx, food_y(%rip)

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
