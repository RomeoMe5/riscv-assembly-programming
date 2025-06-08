#include <stdio.h>

extern int multiply_asm(int a, int b);    // Объявление ассемблерной функции
extern void call_c_function(void);        // Объявление функции для вызова C

void print_message(void) {
    printf("Message from C function!\n"); // Функция, вызываемая из ассемблера
}

int main() {
    int a = 4, b = 5;
    int result = multiply_asm(a, b);      // Вызов ассемблерной функции
    printf("Product of %d and %d is: %d\n", a, b, result);
    call_c_function();                    // Вызов ассемблера, который вызывает C
    return 0;
}
