.section .data
.section .text
.globl _start

_start:



  # Assignment solutions here

  #Task 1: Output.
  /*Use a mov instruction to put a constant in RAX*/
  mov $10, %rax #Moves the constant 10 into the register, RAX

  #Task 2: Looping
  /*Put a constant in, e.g., RAX
  Calculate the sum of 1+2+..+RAX, or RAX+..+3+2+1
  Output that sum
  Hint: Use 'labels' and the conditional branches you learned in the lecture*/
/* Outcomment this, to use the addition function.
  mov $0, %rdx #Moves the constant 0 into the register, RDX
  loopAdd:
  add %rax, %rdx
  sub $1, %rax
  cmp $0, %rax
  jne loopAdd
  mov %rdx, %rax
*/

  #Task 3: Multiplication
  /*Put a constant in, e.g., RAX
  Calculate the product of 1*2*3*..*RAX
  Output that sum
  Hint: Use labels and the conditional branches you learned in the lecture*/
  mov $5, %rax
  mov $-1, %rdx
  add %rax, %rdx
  loopMult:
  mov %rdx, %rdi
  mul %rdx
  mov %rdi, %rdx
  add $-1, %rdx
  cmp $0, %rdx
  jne loopMult

  #Task 4: More Sums
  /*As before, but this time calculate the sum of each multiple of 3 or 5
  from 1 to the chosen constant. (e.g. 3+5+7..+15)*/

  

  #Task 5: GDB
  /*Try out 'gdb'. Step through the program and note the changes of the registers.
  Find the solution from the last through the debugger.*/



  call print_rax          # to print the RAX register

  # Syscall calling sys_exit
  mov $60, %rax            # rax: int syscall number
  mov $0, %rdi             # rdi: int error code
  syscall


.type print_rax, @function
print_rax:
  /* Prints the contents of rax. */

  push  %rbp
  mov   %rsp, %rbp        # function prolog

  push  %rax              # saving the registers on the stack
  push  %rcx
  push  %rdx
  push  %rdi
  push  %rsi
  push  %r9

  mov   $6, %r9           # we always print the 6 characters "RAX: \n"
  push  $10               # put '\n' on the stack

  loop1:
  mov   $0, %rdx
  mov   $10, %rcx
  idiv  %rcx              # idiv alwas divides rdx:rax/operand
                          # result is in rax, remainder in rdx
  add   $48, %rdx         # add 48 to remainder to get corresponding ASCII
  push  %rdx              # save our first ASCII sign on the stack
  inc   %r9               # counter
  cmp   $0, %rax
  jne   loop1             # loop until rax = 0

  mov   $0x20, %rax       # ' '
  push  %rax
  mov   $0x3a, %rax       # ':'
  push  %rax
  mov   $0x58, %rax       # 'X'
  push  %rax
  mov   $0x41, %rax       # 'A"
  push  %rax
  mov   $0x52, %rax       # 'R'
  push  %rax

  print_loop:
  mov   $1, %rax          # Here we make a syscall. 1 in rax designates a sys_write
  mov   $1, %rdi          # rdx: int file descriptor (1 is stdout)
  mov   %rsp, %rsi        # rsi: char* buffer (rsp points to the current char to write)
  mov   $1, %rdx          # rdx: size_t count (we write one char at a time)
  syscall                 # instruction making the syscall
  add   $8, %rsp          # set stack pointer to next char
  dec   %r9
  jne   print_loop

  pop   %r9               # restoring the registers
  pop   %rsi
  pop   %rdi
  pop   %rdx
  pop   %rcx
  pop   %rax

  mov   %rbp, %rsp        # function Epilog
  pop   %rbp
  ret
