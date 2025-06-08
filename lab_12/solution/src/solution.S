# Оптимизированная версия: суммирование квадратов с разворачиванием цикла
.section .data
array: .space 4000000  # 1,000,000 элементов * 4 байта
array_end: .quad array + 4000000
.section .text
.global main
main:
    # Инициализация массива: array[i] = i
    la t0, array
    li t1, 0          # i = 0
    li t2, 1000000    # размер массива
init_loop:
    bge t1, t2, init_end
    sw t1, 0(t0)      # array[i] = i
    addi t0, t0, 4
    addi t1, t1, 1
    j init_loop
init_end:
    # Внешний цикл: повторить суммирование 100 раз
    li t3, 0          # счетчик внешнего цикла
    li t4, 100        # количество итераций
outer_loop:
    bge t3, t4, outer_end
    # Суммирование квадратов с разворачиванием на 4 элемента
    la t0, array
    la t1, array_end
    li t2, 0          # сумма = 0
sum_loop_unrolled:
    bge t0, t1, sum_end
    lw t5, 0(t0)      # первый элемент
    mul t5, t5, t5
    add t2, t2, t5
    lw t5, 4(t0)      # второй элемент
    mul t5, t5, t5
    add t2, t2, t5
    lw t5, 8(t0)      # третий элемент
    mul t5, t5, t5
    add t2, t2, t5
    lw t5, 12(t0)     # четвертый элемент
    mul t5, t5, t5
    add t2, t2, t5
    addi t0, t0, 16   # сдвиг на 4 элемента (16 байт)
    j sum_loop_unrolled
sum_end:
    addi t3, t3, 1    # увеличить счетчик внешнего цикла
    j outer_loop
outer_end:
    mv a0, t2         # последняя сумма в a0
    li a7, 93         # системный вызов для выхода
    ecall
