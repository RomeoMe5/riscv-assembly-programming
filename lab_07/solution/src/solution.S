   .data
src_path:       .asciz "input.txt"             # имя файла-источника
dst_path:       .asciz "output.txt"            # имя файла-приемника
buf:            .space 64                      # буфер для копирования

error_open:     .asciz "Не удалось открыть файл\n"
error_read:     .asciz "Ошибка чтения файла\n"
error_write:    .asciz "Ошибка записи в файл\n"

    .text
    .globl _start

_start:
    # открываем файл-источник на чтение
    li a0, -100
    la a1, src_path
    li a2, 0
    li a3, 0
    li a7, 56
    ecall
    blt a0, zero, open_src_failed
    mv s0, a0               # дескриптор источника

    # открываем файл-приёмник с созданием
    li a0, -100
    la a1, dst_path
    li a2, 577
    li a3, 420
    li a7, 56
    ecall
    blt a0, zero, open_dst_failed
    mv s1, a0               # дескриптор приемника

read_loop:
    # читаем блок из источника
    mv a0, s0
    la a1, buf
    li a2, 64
    li a7, 63
    ecall
    blt a0, zero, read_failed
    beqz a0, close_all      # если a0 == 0, конец файла
    mv s2, a0               # сохраняем количество байт

    # записываем блок в приёмник
   mv a0, s1
    la a1, buf
    mv a2, s2
    li a7, 64
    ecall
    blt a0, zero, write_failed

    j read_loop             # продолжаем

close_all:
    # закрываем оба файла
    mv a0, s0
    li a7, 57
    ecall

    mv a0, s1
    li a7, 57
    ecall

    li a7, 93
    li a0, 0
    ecall

open_src_failed:
    la a1, error_open
    li a2, 29
    li a0, 1
    li a7, 64
    ecall
    j exit_error

open_dst_failed:
    la a1, error_open
    li a2, 29
    li a0, 1
    li a7, 64
    ecall
    j exit_error

read_failed:
    la a1, error_read
    li a2, 27
    li a0, 1
    li a7, 64
    ecall
    j exit_error

write_failed:
    la a1, error_write
    li a2, 28
    li a0, 1
    li a7, 64
    ecall
    j exit_error

exit_error:
    li a7, 93
    li a0, 1
    ecall
