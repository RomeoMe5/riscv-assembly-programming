.data
    prompt:     .asciz "Enter grades:\n" # Ввод в одну строку через пробел (пр. 4 5 3)
    avg_text:   .asciz "Average: "
    fours_text: .asciz "\nNumber of 4s: "
    fives_text: .asciz "\nNumber of 5s: "
    newline:    .asciz "\n"
    input_buf:  .space 32
    output_buf: .space 4

.bss
    .lcomm grades, 12
    .lcomm fours_count, 1
    .align 2
    .lcomm fives_count, 4

.text
.globl _start
_start:
    # Вывод строки prompt
    li a0, 1
    la a1, prompt
    li a2, 15
    li a7, 64
    ecall

    # Чтение ввода
    li a0, 0
    la a1, input_buf
    li a2, 32
    li a7, 63
    ecall

    # Инициализация
    la t0, input_buf
    la t1, grades
    li t2, 0
    la t3, fours_count
    sb zero, 0(t3)
    la t4, fives_count
    sw zero, 0(t4)

parse_loop:
    lb t5, 0(t0)
    beq t5, zero, end_parse
    li t6, 32
    beq t5, t6, skip
    li t6, 10
    beq t5, t6, end_parse
    li t6, 48
    blt t5, t6, skip
    li t6, 57
    bgt t5, t6, skip

    addi t5, t5, -48
    sw t5, 0(t1)
    addi t1, t1, 4

    # Подсчет оценок
    li t6, 4
    beq t5, t6, inc_four
    li t6, 5
    beq t5, t6, inc_five
    j skip_inc

inc_four:
    la t3, fours_count
    lb t6, 0(t3)
    addi t6, t6, 1
    sb t6, 0(t3)
    j skip_inc

inc_five:
    la t4, fives_count
    lw t6, 0(t4)
    addi t6, t6, 1
    sw t6, 0(t4)

skip_inc:
    addi t2, t2, 1
    li t6, 3
    beq t2, t6, end_parse

skip:
    addi t0, t0, 1
    j parse_loop

end_parse:
    la t1, grades
    lw t3, 0(t1)
    lw t4, 4(t1)
    lw t5, 8(t1)
    add s0, t3, t4
    add s0, s0, t5
    li s1, 3
    div s2, s0, s1
    la t0, output_buf
    addi s2, s2, 48
    sb s2, 0(t0)
    sb zero, 1(t0)

    # Вывод среднего арифметического
    li a0, 1
    la a1, avg_text
    li a2, 9
    li a7, 64
    ecall
    li a0, 1
    la a1, output_buf
    li a2, 1
    li a7, 64
    ecall

    # Вывод кол-ва оценок 4
    li a0, 1
    la a1, fours_text
    li a2, 17
    li a7, 64
    ecall
    la t0, fours_count
    lb a0, 0(t0)
    addi a0, a0, 48
    la t1, output_buf
    sb a0, 0(t1)
    li a0, 1
    la a1, output_buf
    li a2, 1
    li a7, 64
    ecall
 
    # Вывод кол-ва оценок 5
    li a0, 1
    la a1, fives_text
    li a2, 17
    li a7, 64
    ecall
    la t0, fives_count
    lw a0, 0(t0)
    addi a0, a0, 48
    la t1, output_buf
    sb a0, 0(t1)
    li a0, 1
    la a1, output_buf
    li a2, 1
    li a7, 64
    ecall

    # Перенос строки
    li a0, 1
    la a1, newline
    li a2, 1
    li a7, 64
    ecall

    # Выход из программы
    li a0, 0
    li a7, 93
    ecall
