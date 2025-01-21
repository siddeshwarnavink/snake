# vi: set ts=2 sw=2 et ft=asm:
#
# snake for x86_64 Linux
# by Siddeshwar <siddeshwar.work@gmail.com>
#

.section .data
SCREEN_WIDTH:   .long 20
SCREEN_HEIGHT:  .long 50
MAX_SCORE:      .long 100

.global SCREEN_WIDTH, SCREEN_HEIGHT, MAX_SCORE

pos_x:    .int 2
pos_y:    .int 2
dir_x:    .int 1
dir_y:    .int 0
food_x:   .int 0
food_y:   .int 0
skip:     .int 0
score:    .long 2       # size of snake
body:     .zero 800     # (4+4)*100

.global pos_x, pos_y, dir_x, dir_y, food_x, food_y, skip, score, body

.section .bss
.align 8
.global win
win:      .skip 8

.section .text
.global _start, exit

.extern keyboard_input
.extern draw_box
.extern spawn_food, render_food, food_collision
.extern render_snake

.render:
  pushq %rbp
  movq %rsp, %rbp

  call clear

  call render_snake

  call render_food

  call draw_box

  movq win(%rip), %rdi
  call refresh

  leave
  ret

.tick:
  pushq %rbp
  movq %rsp, %rbp

  movl dir_x(%rip), %eax
  addl %eax, pos_x(%rip)

  movl dir_y(%rip), %eax
  addl %eax, pos_y(%rip)

  call food_collision
  cmp $1, %eax

  je .respawn_food

  leave
  ret

.respawn_food:
  movl score(%rip), %eax
  addl $1, %eax
  movl %eax, score(%rip)

  call spawn_food

  leave
  ret

_start:
  # just for fun
  movl $10, body(%rip)
  movl $10, body+4(%rip)
  movl $10, body+8(%rip)
  movl $11, body+12(%rip)

  call initscr
  movl %eax, win

  mov win, %rdi
  mov $1, %rsi
  call keypad

  call noecho

  mov $0, %edi
  call curs_set

  mov win, %rdi
  mov $1, %rsi
  call nodelay

  call spawn_food

.game_loop:
  call keyboard_input

  mov skip(%rip), %eax
  cmpl $1, %eax
  je .game_loop_skip

  call .tick

  call .render

  mov $100000, %edi
  call usleep

  jmp .game_loop

.game_loop_skip:
  movl $0, skip(%rip)
  jmp .game_loop

exit:
  call endwin

  mov $60, %rax
  xor %rdi, %rdi
  syscall
