.section .text
.global multiply_asm          # Объявление функции для доступа из C

multiply_asm:
    mul a0, a0, a1           # Умножение a0 на a1, результат в a0
    jr ra
