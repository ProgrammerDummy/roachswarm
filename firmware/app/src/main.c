#include "stm32l476xx.h"

// onboard LED LD2 on NUCLEO-L476RG is connected to PA5
#define LD2_PIN_POS (5U)

void delay() {
    volatile uint64_t num;
    for (num = 0; num < 500000; num++) {
        ;
    }
}

// all citations are from RM0351 Rev 11
int main (void) {
    // enable GPIOA port clock from AHB2 (RM0351, 253)
    RCC->AHB2ENR |= RCC_AHB2ENR_GPIOAEN;

    // "Just after enabling the clock for a peripheral, software must wait for a delay before
    //  accessing the peripheral registers" (RM0351, 222)
    (void)RCC->AHB2ENR;

    // set gpio port a pin 5 (PA5) to GPIO mode (RM0351, 306)
    GPIOA->MODER &= ~(3U << (LD2_PIN_POS * 2U));
    GPIOA->MODER |= (1U << (LD2_PIN_POS * 2U));

    while (1) {
        // toggle LED (RM0351, 308)
        GPIOA->ODR |= (1U << LD2_PIN_POS);
        delay();
        GPIOA->ODR &= ~(1U << LD2_PIN_POS);
        delay();

    }
    return 0;
}
