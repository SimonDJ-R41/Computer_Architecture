#This is a code snippet from lab courses

.section .data
.section .text
.globl _start

_start:



  # Assignment solutions here

  #Task 1: Output.
  /*Use a mov instruction to put a constant in RAX*/
  mov $10, %rax   #Moves the constant 10 into the register, RAX

  #Task 2: Looping
  /*Put a constant in, e.g., RAX
  Calculate the sum of 1+2+..+RAX, or RAX+..+3+2+1
  Output that sum
  Hint: Use 'labels' and the conditional branches you learned in the lecture*/
/* Outcomment this, to use the addition function.*/
  mov $0, %rdx    #Moves the constant 0 into the register, RDX
  loopAdd:
    add %rax, %rdx  #Adds the values in the given registers "rax" and "rdx" and stores the result in the latter.
    sub $1, %rax    #Subtracts the immidiate value "1" from "rax" and stores the result in the latter.
    cmp $0, %rax    #Stores the value of the check "0==rax" in a unspecified cpu flag.
    jne loopAdd     #If the unspecified cpu flag is true, jump to the given instruction/label.
    mov %rdx, %rax
/*
  #Alternative/faster version. f(x) = x*(1+x)/2
  mov %rax, %eax  #x
  add $1, %eax    #x+1
  mul %rax        #x*(x+1)
  shr $1, %eax    #x*(x+1)/2
  mov %eax, %rax
*/

  /*
  TASK 2 (Instructor way)
  Add the number to a sum, and decrement until it reaches 0.
  */

  mov $10, %rax
  mov $0, %rbx

  add_loop:
    add %rax, %rbx
    sub $1, %rax
    cmp $0, %rax
    jne add_loop

    mov %rbx, %rax
  call print_rax   # expected result: 55


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

  /*
  TASK 3 (Instructor way)
  As with before, but here we multiply the number with the product,
  and then decrement until it reaches 0.
  */

  mov $1, %rax
  mov $10, %rbx

  mul_loop:
    mul %rbx        # %rax = %rax * %rbx
    sub $1, %rbx
    cmp $0, %rbx
    jne mul_loop

  call print_rax    # expected result: 10! = 3628800

#-------------------------------------------------------------------------------

  #Task 4: More Sums
  /*As before, but this time calculate the sum of each multiple of 3 or 5
  from 1 to the chosen constant. (e.g. 3+5+7..+15)*/

  #Following will be: 3+5+6+9+12+15+18+20 = 98

  mov $20, %r8
  mov $3, %r9
  mov $5, %r10
  mov $0, %r11

  sum_loop:
    mov $0, %rdx
    mov $20, %rax
    idiv %r9
    cmp $0, %rdx
    je add_number

    mov $0, %rdx
    mov %r8, %rax
    idiv %r10
    cmp $0, %rdx
    jne end

  add_number:
    add %r8, %r11

  end:
    sub $1, %r8
    cmp $0, %r8
    jne sum_loop

  mov %r11, %rax
  call print_rax

  #Task 5: GDB
  /*Try out 'gdb'. Step through the program and note the changes of the registers.
  Find the solution from the last through the debugger.*/

  end_result:   # For task 5, in gdb create a breakpoint here with "break end_result",
                # run the program, and then use "info register rax" to print the result

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
