# vi: set ts=2 sw=2 et ft=asm:
#
# snake for x86_64 Linux
# by Siddeshwar <siddeshwar.work@gmail.com>
#

.section .data
msg:      .string "Hello, World!\n"

.section .text
.global _start
.extern initscr keypad noecho nodalay curs_set printw getch endwin

_start:
  call initscr

  mov %rax, %rdi
  mov $1, %rsi
  call keypad

  call noecho

  call nodelay

  mov $0, %rdi
  call curs_set

  mov $msg, %rdi
  call printw

  call getch

  call endwin

  mov $60, %rax
  xor %rdi, %rdi
  syscall
