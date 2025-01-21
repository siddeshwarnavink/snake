# vi: set ts=2 sw=2 et ft=asm:

.section .data
.equ KEY_ESC, 27

.equ KEY_UP, 259
.equ KEY_DOWN, 258
.equ KEY_LEFT, 260
.equ KEY_RIGHT, 261

.extern dir_x, dir_y, skip

.section .bss
.align 8

.extern win

.section .text

.extern exit

.global keyboard_input

keyboard_input:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp

  movq win(%rip), %rax
  movq %rax, %rdi
  call wgetch
  movl %eax, -4(%rbp)

  cmpl $KEY_ESC, -4(%rbp)
  je exit

  cmpl $KEY_UP, -4(%rbp)
  je .call_move_up

  cmpl $KEY_DOWN, -4(%rbp)
  je .call_move_down

  cmpl $KEY_LEFT, -4(%rbp)
  je .call_move_left

  cmpl $KEY_RIGHT, -4(%rbp)
  je .call_move_right

  jmp done

.call_move_up:
  movl dir_y(%rip), %eax
  cmpl $1, %eax
  je .skip_move_up

  call .move_up
  jmp done

.skip_move_up:
  movl $1, %eax
  movl %eax, skip(%rip)
  jmp done

.call_move_down:
  movl dir_y(%rip), %eax
  cmpl $-1, %eax
  je .skip_move_down

  call .move_down
  jmp done

.skip_move_down:
  movl $1, %eax
  movl %eax, skip(%rip)
  jmp done

.call_move_left:
  movl dir_x(%rip), %eax
  cmpl $1, %eax
  je .skip_move_left

  call .move_left
  jmp done

.skip_move_left:
  movl $1, %eax
  movl %eax, skip(%rip)
  jmp done

.call_move_right:
  movl dir_x(%rip), %eax
  cmpl $-1, %eax
  je .skip_move_right

  call .move_right
  jmp done

.skip_move_right:
  movl $1, %eax
  movl %eax, skip(%rip)
  jmp done

done:
  leave
  ret

.move_up:
  pushq %rbp
  movq %rsp, %rbp

  movl $0, %eax
  movl %eax, dir_x(%rip)
  movl $-1, %eax
  movl %eax, dir_y(%rip)

  leave
  ret

.move_down:
  pushq %rbp
  movq %rsp, %rbp

  movl $0, %eax
  movl %eax, dir_x(%rip)
  movl $1, %eax
  movl %eax, dir_y(%rip)

  leave
  ret

.move_left:
  pushq %rbp
  movq %rsp, %rbp

  movl $-1, %eax
  movl %eax, dir_x(%rip)
  movl $0, %eax
  movl %eax, dir_y(%rip)

  leave
  ret

.move_right:
  pushq %rbp
  movq %rsp, %rbp

  movl $1, %eax
  movl %eax, dir_x(%rip)
  movl $0, %eax
  movl %eax, dir_y(%rip)

  leave
  ret
