.data
    prompt:         .asciz  "Введите цифру от 0 до 9: "
    result_text:    .asciz  "\nСумма: "
    newline:        .asciz  "\n"
    input_buffer:   .space  4
    zero_ascii:     .byte   '0'

.text
.globl main
main:
    li a7, 4
    la a0, prompt
    ecall

    li a7, 8
    la a0, input_buffer
    li a1, 2
    ecall

    la t6, input_buffer
    lb t0, 0(t6)
    addi t0, t0, -48
    andi t1, t0, 1
    li t2, 0
    li t3, 0
    beqz t1, even_loop

odd_loop:
    li t4, 1
odd_loop_start:
    bgt t4, t0, done
    add t2, t2, t4
    addi t4, t4, 2
    j odd_loop_start

even_loop:
    li t4, 0
even_loop_start:
    bgt t4, t0, done
    add t2, t2, t4
    addi t4, t4, 2
    j even_loop_start

done:
    li a7, 4
    la a0, result_text
    ecall

    li t3, 10
    li t4, 0
    mv t6, t2

print_loop:
    beqz t6, check_zero
    remu t5, t6, t3
    addi t5, t5, 48
    addi sp, sp, -1
    sb t5, 0(sp)
    addi t4, t4, 1
    divu t6, t6, t3
    j print_loop

check_zero:
    beq t4, zero, print_zero
    li a7, 64
    li a0, 1
    mv a1, sp
    mv a2, t4

    ecall
    j newline_out

print_zero:
    li a7, 64
    li a0, 1
    la a1, zero_ascii
    li a2, 1
    ecall

newline_out:
    li a7, 4
    la a0, newline
    ecall

    li a7, 10
    ecall
