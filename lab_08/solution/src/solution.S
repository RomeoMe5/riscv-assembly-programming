.text
.align 2

# Точка входа программы
.globl main
.type main, @function
main:
    # Пролог: настройка стека
    addi sp, sp, -16      # Выделяем 16 байт на стеке
    sw   ra, 12(sp)       # Сохраняем адрес возврата
    sw   s0, 8(sp)        # Сохраняем регистр s0
    addi s0, sp, 16       # Устанавливаем s0 как указатель на базу стека

    # Инициализация системы
    call SystemClock_Config  # Настраиваем системные часы
    call GPIO_Init           # Инициализируем GPIO

    # Бесконечный цикл переключения пина для сигнала SOS
loop:
    # Три коротких сигнала
    li   a0, 0x00084400       # Адрес порта GPI1 (GPIOA_BASE)
    li   a1, 4                # Номер пина (GPIO_PIN_9)
    call HAL_GPIO_TogglePin   # Включить
    li   a0, 200              # Задержка 200 мс
    call HAL_DelayMs
    li   a0, 0x00084400
    li   a1, 4
    call HAL_GPIO_TogglePin   # Выключить
    li   a0, 200
    call HAL_DelayMs

    li   a0, 0x00084400
    li   a1, 4
    call HAL_GPIO_TogglePin   # Включить
    li   a0, 200
    call HAL_DelayMs
    li   a0, 0x00084400
    li   a1, 4
    call HAL_GPIO_TogglePin   # Выключить
    li   a0, 200
    call HAL_DelayMs

    li   a0, 0x00084400
    li   a1, 4
    call HAL_GPIO_TogglePin   # Включить
    li   a0, 200
    call HAL_DelayMs
    li   a0, 0x00084400
    li   a1, 4
    call HAL_GPIO_TogglePin   # Выключить
    li   a0, 200
    call HAL_DelayMs

    # Три длинных сигнала
    li   a0, 0x00084400
    li   a1, 4
    call HAL_GPIO_TogglePin   # Включить
    li   a0, 600              # Задержка 600 мс
    call HAL_DelayMs
    li   a0, 0x00084400
    li   a1, 4
    call HAL_GPIO_TogglePin   # Выключить
    li   a0, 200
    call HAL_DelayMs

    li   a0, 0x00084400
    li   a1, 4
    call HAL_GPIO_TogglePin   # Включить
    li   a0, 600
    call HAL_DelayMs
    li   a0, 0x00084400
    li   a1, 4
    call HAL_GPIO_TogglePin   # Выключить
    li   a0, 200
    call HAL_DelayMs

    li   a0, 0x00084400
    li   a1, 4
    call HAL_GPIO_TogglePin   # Включить
    li   a0, 600
    call HAL_DelayMs
    li   a0, 0x00084400
    li   a1, 4
    call HAL_GPIO_TogglePin   # Выключить
    li   a0, 200
    call HAL_DelayMs

    # Три коротких сигнала
    li   a0, 0x00084400
    li   a1, 4
    call HAL_GPIO_TogglePin   # Включить
    li   a0, 200
    call HAL_DelayMs
    li   a0, 0x00084400
    li   a1, 4
    call HAL_GPIO_TogglePin   # Выключить
    li   a0, 200
    call HAL_DelayMs

    li   a0, 0x00084400
    li   a1, 4
    call HAL_GPIO_TogglePin   # Включить
    li   a0, 200
    call HAL_DelayMs
    li   a0, 0x00084400
    li   a1, 4
    call HAL_GPIO_TogglePin   # Выключить
    li   a0, 200
    call HAL_DelayMs

    li   a0, 0x00084400
    li   a1, 4
    call HAL_GPIO_TogglePin   # Включить
    li   a0, 200
    call HAL_DelayMs
    li   a0, 0x00084400
    li   a1, 4
    call HAL_GPIO_TogglePin   # Выключить
    li   a0, 1000             # Пауза 1000 мс
    call HAL_DelayMs

    j    loop             # Повторяем цикл

# Функция настройки часов
.globl SystemClock_Config
.type SystemClock_Config, @function
SystemClock_Config:
    # Пролог: настройка стека
    addi sp, sp, -80      # Выделяем 80 байт на стеке
    sw   ra, 76(sp)       # Сохраняем адрес возврата
    sw   s0, 72(sp)       # Сохраняем регистр s0
    addi s0, sp, 80       # Устанавливаем s0 как указатель на базу стека

    # Инициализация структуры PCC (Peripheral Clock Control)
    li   t0, 15           # Источник тактирования (например, внешний осциллятор)
    sb   t0, -56(s0)      # Записываем в поле структуры
    li   t0, 2            # Делитель частоты
    sb   t0, -52(s0)      # Записываем в поле структуры
    sw   zero, -48(s0)    # Остальные поля обнуляем
    li   t0, 2            # Режим работы PLL
    sw   t0, -44(s0)      # Записываем в поле структуры
    sw   zero, -40(s0)    # Обнуляем остальные поля
    sw   zero, -36(s0)
    sw   zero, -32(s0)
    li   t0, -128         # Конфигурация тактирования (старший байт)
    sb   t0, -28(s0)
    li   t0, 8            # Множитель частоты
    sb   t0, -27(s0)
    sw   zero, -24(s0)    # Обнуляем оставшиеся поля
    sw   zero, -20(s0)

    # Вызов функции настройки часов
    addi a0, s0, -80      # Указатель на временную структуру
    addi a1, s0, -56      # Указатель на конфигурацию PCC
    call HAL_PCC_Config   # Применяем настройки часов

    # Эпилог: восстановление стека
    lw   ra, 76(sp)       # Восстанавливаем адрес возврата
    lw   s0, 72(sp)       # Восстанавливаем s0
    addi sp, sp, 80       # Освобождаем стек
    jr   ra               # Возвращаемся

# Функция инициализации GPIO
.globl GPIO_Init
.type GPIO_Init, @function
GPIO_Init:
    # Пролог: настройка стека
    addi sp, sp, -32      # Выделяем 32 байта на стеке
    sw   ra, 28(sp)       # Сохраняем адрес возврата
    sw   s0, 24(sp)       # Сохраняем регистр s0
    addi s0, sp, 32       # Устанавливаем s0 как указатель на базу стека

    # Настройка режима порта
    li   t0, 327680       # Базовый адрес регистра GPIO (PORTA)
    li   t1, 4096         # Режим вывода (GPIO_MODE_OUTPUT)
    sw   t1, 28(t0)       # Устанавливаем режим для пина
    li   t1, 8192         # Альтернативная функция (если требуется)
    sw   t1, 28(t0)       # Записываем в тот же регистр

    # Инициализация структуры GPIO
    li   t0, 4          # Номер пина (GPIO_PIN_9)
    sw   t0, -32(s0)      # Записываем в поле структуры
    sw   zero, -28(s0)    # Обнуляем остальные поля
    sw   zero, -24(s0)
    sw   zero, -20(s0)
    # Вызов функции инициализации GPIO
    li   a0, 0x00084400       # Адрес порта GPIO (GPIOA_BASE)
    addi a1, s0, -32      # Указатель на структуру GPIO
    call HAL_GPIO_Init    # Инициализируем пин

    # Эпилог: восстановление стека
    lw   ra, 28(sp)       # Восстанавливаем адрес возврата
    lw   s0, 24(sp)       # Восстанавливаем s0
    addi sp, sp, 32       # Освобождаем стек
    jr   ra               # Возвращаемся
