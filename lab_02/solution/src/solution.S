# Пример: вывод числа в консоль
    .data
msg:    .ascii  "Result: "  # префикс для более аккуратного вывода
num:    .word   64          # пример числа
buf:    .space  2           # буфер под две ASCII-цифры
nl:     .ascii  "\n"        # перевод строки

    .text
    .globl _start
    .align 2
_start:
    # -- загрузка числа
    la    t0, num
    lw    t0, 0(t0)         # t0 ← 64

    # -- разбиение числа на разряды
    li    t1, 10
    div   t2, t0, t1        # t2 = 64 / 10 = 6
    rem   t3, t0, t1        # t3 = 64 % 10 = 4

    # -- преобразование в ASCII
    addi  t2, t2, '0'       # '6'
    addi  t3, t3, '0'       # '4'

    # -- посимвольная запись в буфер buf[0..1]
    la    t4, buf
    sb    t2, 0(t4)         # buf[0] = '6'
    sb    t3, 1(t4)         # buf[1] = '4'

    # -- вывод "Result: "
    li    a0, 1             # stdout
    la    a1, msg
    li    a2, 8             # длина строки "Result: " составляет 8 символов
    li    a7, 64            # sys_write
    ecall

    # -- вывод всех элементов буфера
    li    a0, 1
    mv    a1, t4            # адрес buf
    li    a2, 2
    li    a7, 64
    ecall

    # -- перевод строки
    li    a0, 1
    la    a1, nl
    li    a2, 1
    li    a7, 64
    ecall

    # -- завершение
    li    a0, 0
    li    a7, 93            # sys_exit
    ecall
