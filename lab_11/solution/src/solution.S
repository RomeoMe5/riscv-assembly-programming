.section .data
.align 8                    # Выравнивание на 8 байт для double
a:          .double 1.0     # Число a
b:          .double 2.0     # Число b
c:          .double 3.0     # Число c
ref:        .double 7.0     # Ожидаемое значение (1 + 2 * 3 = 7)
eps:        .double 1e-10   # Epsilon для проверки
ok_msg:     .asciz "OK\n"   # Сообщение для верного результата
notok_msg:  .asciz "NOT OK\n" # Сообщение для неверного результата

.section .text
.global _start
_start:
    # Загрузка чисел из памяти
    la t0, a                # t0 = адрес a (используем t0 вместо x5)
    fld f0, 0(t0)           # f0 = a
    la t0, b
    fld f1, 0(t0)           # f1 = b
    la t0, c
    fld f2, 0(t0)           # f2 = c
    la t0, ref
    fld f6, 0(t0)           # f6 = ref
    la t0, eps
    fld f5, 0(t0)           # f5 = eps

    # Вычисление a + b * c
    fmul.d f4, f1, f2       # f4 = b * c
    fadd.d f3, f0, f4       # f3 = a + b * c

    # Вычисление |f3 - ref|
    fsub.d f4, f3, f6       # f4 = f3 - ref
    fabs.d f4, f4           # f4 = |f3 - ref|

    # Проверка |f3 - ref| < eps
    flt.d t1, f4, f5        # t1 = 1, если |f3 - ref| < eps, иначе 0

    # Вывод результата
    beq t1, zero, print_not_ok

print_ok:
    li a7, 64               # Системный вызов write (64 вместо 4 для QEMU)
    li a0, 1                # Дескриптор файла (stdout = 1)
    la a1, ok_msg           # Адрес строки OK
    li a2, 3                # Длина строки OK\n
    ecall
    j exit

print_not_ok:
    li a7, 64               # Системный вызов write
    li a0, 1                # Дескриптор файла (stdout = 1)
    la a1, notok_msg        # Адрес строки NOT OK
    li a2, 8                # Длина строки NOT OK\n
    ecall

exit:
    li a7, 93               # Системный вызов exit (93 вместо 10 для QEMU)
    li a0, 0                # Код возврата 0
    ecall
