# vi: set ts=2 sw=2 et ft=asm:
#
# snake for x86_64 Linux
# by Siddeshwar <siddeshwar.work@gmail.com>
#

.section .data
.equ SCREEN_WIDTH, 20
.equ SCREEN_HEIGHT, 50

.global pos_x, pos_y, dir_x, dir_y, SCREEN_WIDTH, SCREEN_HEIGHT
head:     .string "O"
pos_x:    .int 0
pos_y:    .int 0
dir_x:    .int 1
dir_y:    .int 0

.section .bss
.align 8
.global win
win:      .skip 8

.section .text
.global _start, exit

.extern keyboard_input
.extern draw_box

.render:
  pushq %rbp
  movq %rsp, %rbp

  call clear

  mov pos_y(%rip), %esi
  mov pos_x(%rip), %edi
  leaq head(%rip), %rdx
  call mvprintw

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

  leave
  ret

_start:
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

.game_loop:
  call keyboard_input

  call .tick

  call .render

  mov $100000, %edi
  call usleep

  jmp .game_loop

exit:
  call endwin

  mov $60, %rax
  xor %rdi, %rdi
  syscall
