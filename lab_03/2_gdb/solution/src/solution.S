.global main

.section .text

main:
    # Вывести оригинальную строку
    la a0, src_string
    jal ra, print_string

    # Скопировать строку
    la a0, src_string
    la a1, dest_buffer
    jal ra, buggy_strcpy

    # Вывести скопированную строку
    la a0, dest_buffer
    jal ra, print_string

    # Выйти из программы
    li a0, 0
    li a7, 93
    ecall

# Функция копирования строки с ошибкой
buggy_strcpy:
    mv t0, a0              # Указатель на источника (src)
    mv t1, a1              # Указатель на результат (dest)

copy_loop:
    lb t2, 0(t0)           # Загрузить байт из src
    sb t2, 0(t1)           # Сохранить байт в dest
    beqz t2, copy_done     # Закончить на терминирующем нуле
    addi t0, t0, 1         # Увеличить указатель src
    addi t1, t1, 1         # Увеличить указатель dest
    j copy_loop            # Повторить

copy_done:
    ret                    # Вернуться к месту вызова

# Вывести строку (читает до терминирующего нуля)
print_string:
    # Вычислить длину строки через поиск терминирующего нуля
    mv t0, a0              # Адрес строки
    li t1, 0               # Счетчик длины

length_loop:
    lb t2, 0(t0)
    beqz t2, print_it      # Остановиться на терминирующем нуле
    addi t0, t0, 1
    addi t1, t1, 1
    j length_loop

print_it:
    # Вызвать системный вызов записи
    li a0, 1               # вывод в stdout
    mv a1, t0              # текущая позиция
    sub a1, t0, t1         # вычисление адреса начала
    mv a2, t1              # длина
    li a7, 64              # запись номера системного вызова
    ecall

    # Вывод переноса строки («\n»)
    li a0, 1
    la a1, newline
    li a2, 1
    li a7, 64
    ecall

    ret

.section .data
# Переменные, записанные в памяти последовательно
src_string:   .asciz "Hello RISC-V"      # Оригинальная строка
dest_buffer:  .space 12                  # Память для результата
                                         # (конкретный размер)
new_string:   .asciz "...Copy Failed"    # Данные сразу после
                                         # результата
newline:      .ascii "\n"
