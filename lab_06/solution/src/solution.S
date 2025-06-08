.data
buffer:         .space 32              # буфер под строку результата
label:          .asciz "Factorial:\n"  # строка с переводом строки
newline:        .byte 10               # отдельный перевод строки

    .text
    .globl _start

.macro SAVE_REGS
    addi sp, sp, -12                   # резервируем место в стеке
    sw ra, 8(sp)                       # сохраняем ra
    sw s0, 4(sp)                       # сохраняем s0
    sw s1, 0(sp)                       # сохраняем s1
.endm

.macro RESTORE_REGS
    lw s1, 0(sp)                       # восстанавливаем s1
    lw s0, 4(sp)                       # восстанавливаем s0
    lw ra, 8(sp)                       # восстанавливаем ra
    addi sp, sp, 12                    # возвращаем sp
.endm

# функция факториала: вход -- a0, выход -- a0
factorial:
    SAVE_REGS
    li t0, 1
    ble a0, t0, base_case

    mv s0, a0
    addi a0, a0, -1
    jal ra, factorial
    mul a0, a0, s0
    j factorial_end

base_case:
    li a0, 1

factorial_end:
    RESTORE_REGS
    jalr zero, 0(ra)

# преобразование числа в строку
int_to_str:
    li t0, 10
    la t1, buffer

   mv t2, t1
    li t3, 0

to_str_loop:
    rem t4, a0, t0
    addi t4, t4, 48
    sb t4, 0(t1)
    addi t1, t1, 1
    addi t3, t3, 1
    div a0, a0, t0
    bnez a0, to_str_loop

    sb zero, 0(t1)

    li t5, 0
    addi t3, t3, -1
reverse_loop:
    bge t5, t3, reverse_done

    lb t6, 0(t2)
    add t4, t2, t3
    lb a4, 0(t4)

    sb a4, 0(t2)
    sb t6, 0(t4)

    addi t5, t5, 1
    addi t2, t2, 1
    addi t3, t3, -1
    j reverse_loop

reverse_done:
    # добавляем символ новой строки в конец
    li t0, 10
    sb t0, 0(t1)
    addi t1, t1, 1
    sb zero, 0(t1)
    ret

# вывод строки по адресу в a1, длина в a2
print_string:
    li a0, 1
    li a7, 64
    ecall
    ret

# точка входа
_start:
    li a0, 5          # кладём в a0 значение числа, факториал которого будем вычислять
    jal ra, factorial
    mv s1, a0

    la a1, label
    li a2, 11                   # длина строки "Factorial:\n"
    jal ra, print_string

    mv a0, s1
    jal ra, int_to_str

    la a1, buffer
    li a2, 32
    jal ra, print_string

    li a7, 93
    ecall
