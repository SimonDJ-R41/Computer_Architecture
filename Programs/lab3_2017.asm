.section .data

tooLarge:
  .string "Input is too large, try lower.\n"
tooSmall:
  .string "Input is too small, try higher.\n"
correct:
  .string "You guessed right.\n"
buffer:
  .space 8

.section .text
.globl _start

_start:

  # Task 1

  mov $63, %r10                # constant to guess
#  call print_rax

  guess:
    /* Syscall: read string from stdin */
    mov $0, %rax              # 0 for read-only
    mov $0, %rdi 			        # 0 is file descriptor for stdin
    mov $buffer, %rsi		      # we want to save string in "buffer"
    mov $8, %rdx			        # number of bytes we want to read (8 characters)
    syscall

    mov $buffer, %rax         # moves what's given to the buffer, into r8
    call string_to_int        # ^we moved it to r15, to use this function
    call print_rax            # prints RAX, making sure it accepts it
    mov %rax, %r15

    cmp %r15, %r10            # compares the guess with the constant value in EAX

    jl lower

    jg greater

    je equal

    lower:
      mov $1, %rax
      mov $1, %rdi
      mov $tooSmall, %rsi
      mov $31, %rdx
      syscall
      jmp guess

    greater:
      mov $1, %rax
      mov $1, %rdi
      mov $tooLarge, %rsi
      mov $30, %rdx
      syscall
      jmp guess

    equal:
      mov $1, %rax
      mov $1, %rdi
      mov $correct, %rsi
      mov $19, %rdx
      syscall

      mov $60, %rax
      mov $0, %rdi
      syscall

    # Task 2

#-------------------------------------------------------------------------------

.type string_to_int, @function
string_to_int:
  /* Converts a string to an integer. Returns the integer in %rax.
   * %rax: Address of string to convert.
   */

  push %rbp
  mov %rsp, %rbp

  push %rbx
  push %rcx
  push %r8

  mov %rax, %r8

  xor %rax, %rax
  convertloop:
    movzx (%r8), %rbx     # moves a single character from the string in memory to %rbx
    cmp $48, %rbx         # If the character is anything less than ascii number 48, then we have reached the end.
  jl convertdone
    mov $10, %rcx
    mul %rcx              # mult multiplies %rax with the given operand and saves the result in %rdx:%rax.
                          # I multiply by 10 to shift the number one placement to the right to add the newest integer.
    sub $48, %rbx         # In ascii, numbers start at 0 = 48, 1 = 49, 2 = 50 and so on. So I subtract 48 to get the digit.
    add %rbx, %rax        # I add the newly read digit to our final integer.
    inc %r8               # Increment the pointer to get the next character.
  jmp convertloop
  convertdone:

  pop %r8
  pop %rcx
  pop %rbx

  mov %rbp, %rsp
  pop %rbp
  ret

#-------------------------------------------------------------------------------

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
