#!/bin/bash

# Сборка ассемблерных файлов
mkdir -p obj
riscv64-linux-gnu-as -o obj/multiply.o src/multiply.s
riscv64-linux-gnu-as -o obj/call_c.o src/call_c.s

# Компиляция C-файла
riscv64-linux-gnu-gcc -c -o obj/main.o src/main.c

# Компоновка
mkdir -p build
riscv64-linux-gnu-gcc -o build/program obj/main.o obj/multiply.o obj/call_c.o

# Запуск в QEMU
qemu-riscv64 ./build/program
