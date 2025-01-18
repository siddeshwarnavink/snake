# vi: set ts=2 sw=2 et ft=asm:
#
# snake for x86_64 Linux
# by Siddeshwar <siddeshwar.work@gmail.com>
#

.section .data
.equ SCREEN_WIDTH, 25
.equ SCREEN_HEIGHT, 20
.equ KEY_ESC, 27

head:     .string "O"
pos_x:    .int 0
pos_y:    .int 0
dir_x:    .int 1
dir_y:    .int 0

.section .bss
.align 8
win:      .skip 8

.section .text
.global _start

user_input:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp

  movq win(%rip), %rax
  movq %rax, %rdi
  call wgetch
  movl %eax, -4(%rbp)

  cmpl $KEY_ESC, -4(%rbp)
  je exit

  leave
  ret

render:
  pushq %rbp
  movq %rsp, %rbp

  call clear

  movq win(%rip), %rdi
  movl pos_y(%rip), %esi
  movl pos_x(%rip), %edx
  movq $head, %rcx
  call mvprintw

  movq win(%rip), %rdi
  call refresh

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


game_loop:
  call user_input

  call render

  mov $1000000, %edi
  call usleep

  jmp game_loop

exit:
  call endwin

  mov $60, %rax
  xor %rdi, %rdi
  syscall
