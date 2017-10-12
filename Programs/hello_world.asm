.section .data
hello: .ascii "Hello World!\n" #Tells Assembler to allocate this much space

.section .text
.globl _start
_start:
  mov $1, %rax    #Write syscall ((1, Write) (2, ) (3, ))
  mov $1, %rdi    #1 is a file descriptor for stdout
  mov $hello,%rsi #Represents the "hello:" ascii statement (also known as a label)
  mov $13,%rdx    #Represents the amount of bytes you'd want to write
  syscall

  mov $60, %rax
  mov $0, %rdi
  syscall
