.section .text
.global call_c_function      # Объявление функции для доступа из C

call_c_function:
    addi sp, sp, -16         # Выделение места в стеке
    sd ra, 8(sp)             # Сохранение адреса возврата
    jal print_message        # Вызов C-функции print_message
    ld ra, 8(sp)             # Восстановление адреса возврата
    addi sp, sp, 16          # Освобождение стека
    jr ra                    # Возврат
