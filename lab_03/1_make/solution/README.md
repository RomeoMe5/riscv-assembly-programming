# Правила кросс-компиляции на Unix-системах под MIK32 Амур

## Структура проекта

- `src/` – папка с исходниками проекта (все `*.c`, `*.S` файлы),
- `Makefile` – файл правил сборки проекта,
- `Makefile.conf` – файл с определением переменных и констант сборки,
- `Makefile.deps` – файл правил установки набора инструментов и зависимых проектов.

## Запуск

```bash
make    # проверка установки тулчейна,
        # установка зависимых проектов (при необходимости),
        # сборка программы /build/$(PROJECT_NAME).hex

make clean              # очистка временных файлов и результатов сборки (obj/ и build/)
make install-toolchain  # установка тулчейна (~/.local/xPacks/riscv-none-elf-gcc/)
make install-openocd    # установка openocd (~/.local/xPacks/openocd/)
make install-deps       # установка зависимых проектов
make delete-tools       # удаление установленных тулчейна и openocd
make delete-deps        # удаление зависимых проектов
make purge              # make clean delete-tools delete-deps
```

### Запуск прошивки микроконтроллера

```bash
make upload
```
