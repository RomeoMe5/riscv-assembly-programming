#!/bin/bash

# Компиляция C-расширения
riscv64-linux-gnu-gcc \
    -shared -fPIC \
    -o build/myasm.so \
    src/extension.c obj/multiply.o \
    -I/usr/include/python3.12 \
    -L/usr/lib \
    -lpython3.12

# Запуск Python-скрипта. Опция -B выполняет сдвиг адресов.
# В случае ошибки компиляции, попробуйте изменить это значение
qemu-riscv64 \
    -B 0x100000000 \
    -L /usr/riscv64-linux-gnu /usr/bin/python3 \
    src/test.py
