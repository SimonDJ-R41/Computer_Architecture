.section .data
hello: .ascii "Hello World!\n"

.section .text
.globl _start
_start:
  mov $1, %rax
  mov $1, %rdi
  mov $hello,%rsi #Represents the "hello:" ascii statement.
  mov $13,%rdx #Represents the amount of bits required.
  syscall

  mov $60, %rax
  mov $0, %rdi
  syscall
