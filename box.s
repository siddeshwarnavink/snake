# vi: set ts=2 sw=2 et ft=asm:

.section .data
.extern SCREEN_WIDTH, SCREEN_HEIGHT

.section .text
.global draw_box

draw_box:
  pushq %rbp
  movq %rsp, %rbp

  movq $0, %rdi
  movq $0, %rsi
  movq $'+', %rdx
  call mvaddch

  movl SCREEN_HEIGHT(%rip), %esi
  movq $0, %rdi
  movq $'+', %rdx
  call mvaddch

  movl SCREEN_WIDTH(%rip), %edi
  movq $0, %rsi
  movq $'+', %rdx
  call mvaddch

  movl SCREEN_HEIGHT(%rip), %esi
  movl SCREEN_WIDTH(%rip), %edi
  movq $'+', %rdx
  call mvaddch

  call .horizontal_lines

  call .vertical_lines

  leave
  ret

.horizontal_lines:
  pushq %rbp
  movq %rsp, %rbp

  subq $8, %rsp
  movq $1, -8(%rbp)

.horizontal_loop:
  movq -8(%rbp), %rax
  movl SCREEN_HEIGHT(%rip), %edx
  cmpq %rdx, %rax
  jge .horizontal_done

  movq $0, %rdi
  movq -8(%rbp), %rsi
  movq $'-', %rdx
  call mvaddch

  movl SCREEN_WIDTH(%rip), %edx
  movq %rdx, %rdi
  movq -8(%rbp), %rsi
  movq $'-', %rdx
  call mvaddch

  addq $1, -8(%rbp)
  jmp .horizontal_loop

.horizontal_done:
  leave
  ret

.vertical_lines:
  pushq %rbp
  movq %rsp, %rbp

  subq $8, %rsp
  movq $1, -8(%rbp)

.vertical_loop:
  movq -8(%rbp), %rax
  movl SCREEN_WIDTH(%rip), %edx
  cmpq %rdx, %rax
  jge .vertical_done

  movq $0, %rsi
  movq -8(%rbp), %rdi
  movq $'|', %rdx
  call mvaddch

  movl SCREEN_HEIGHT(%rip), %edx
  movq %rdx, %rsi
  movq -8(%rbp), %rdi
  movq $'|', %rdx
  call mvaddch

  addq $1, -8(%rbp)
  jmp .vertical_loop

.vertical_done:
  leave
  ret
