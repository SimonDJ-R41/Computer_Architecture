.section .data

my_string:
  .string "Hello World!\n"
buffer:
  .space 8

fstat:
  .space 144

.section .text

.global _start
_start:

/* TASK 1 */

	/* Syscall: write string to stdout */
	mov $1, %rax
	mov $1, %rdi 			      # 1 is file descriptor for stdout
	mov $my_string, %rsi		# string we want to write is "my_string"
	mov $13, %rdx			      # number of bytes we want to write (13 characters)
	syscall

/* TASK 2 */

	/* Retrieve string from command line argument */
	mov 16(%rsp), %rax
	mov %rax, %rcx
	call get_string_length	# save length of command line argument in register RAX
	mov %rax, %rdx		 	    # number of bytes we want to write (used in syscall)

	/* Syscall: write string to stdout */
	mov $1, %rax
	mov $1, %rdi 		      	  # 1 is file descriptor for stdout
	mov %rcx, %rsi			      # register RCX holds pointer to string we want to write
	syscall

/* TASK 3 */

	/* Syscall: read string from stdin */
	mov $0, %rax
	mov $0, %rdi 			        # 0 is file descriptor for stdin
	mov $buffer, %rsi		      # we want to save string in "buffer"
	mov $8, %rdx			        # number of bytes we want to read (8 characters)
	syscall

	mov $buffer, %rax
	call get_string_length    # save actual length of string in register RAX
	mov %rax, %rdx			      # number of bytes we want to write

	/* Syscall: write string to stdout */
	mov $1, %rax
	mov $1, %rdi 			        # 1 is file descriptor for stdout
	mov $buffer, %rsi		      # string we want to write is in "buffer"
	syscall

/* TASK 4 */

	/* Retrieve file name from command line argument */
	mov 16(%rsp), %rcx

	/* Syscall: open file */
	mov $2, %rax
	mov %rcx, %rdi 			  # address of file name is in register RCX
	mov $0, %rsi
	mov $2, %rdx			    # open in read-write mode
	syscall

	/* NB: File descriptor for our file is now in %rax */
	mov %rax, %rcx

	/* Syscall: read n chars from file */
	mov $0, %rax
	mov %rcx, %rdi 			  # %rcx is file descriptor for our file
	mov $buffer, %rsi		  # we want to save string in "buffer"
	mov $8, %rdx			    # number of bytes we want to read (8 characters)
	syscall

	/* Syscall: write string to stdout */
	mov $1, %rax
	mov $1, %rdi 			    # 1 is file descriptor for stdout
	mov $buffer, %rsi		  # string we want to write is in "buffer"
	mov $8, %rdx			    # number of bytes we want to write (8 characters)
	syscall

# Syscall calling sys_exit
	mov $60, %rax         # rax: int syscall number
	mov $0, %rdi          # rdi: int error code
	syscall

.type get_string_length, @function
get_string_length:
  /* Dertermines the length of a zero-terminated string. Returns result in %rax.
   * %rax: Address of string.
   */
  push %rbp
  mov %rsp, %rbp

  push %rcx
  push %rbx
  push %rdx
  push %rsi
  push %r11

  xor %rdx, %rdx

  # Get string length
  lengthLoop:
    movb (%rax), %bl    # Read a byte from string
    cmp $0, %bl         # If byte == 0: end loop
  je lengthDone
    inc %rdx
    inc %rax
  jmp lengthLoop
  lengthDone:

  mov %rdx, %rax

  pop %r11
  pop %rsi
  pop %rdx
  pop %rbx
  pop %rcx

  mov %rbp, %rsp
  pop %rbp
  ret
