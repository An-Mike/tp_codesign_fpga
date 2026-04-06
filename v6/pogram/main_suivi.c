#include <stdint.h>

// Définition des adresses mémoire
#define START_SL   (*(volatile uint32_t*)0x04003040)
#define START_ROT  (*(volatile uint32_t*)0x04003030)
#define DIR_ROT    (*(volatile uint32_t*)0x04003020)
#define FIN_SL     (*(volatile uint32_t*)0x04003010)
#define FIN_ROT    (*(volatile uint32_t*)0x04003000)

void delay(volatile int count)
{
    while (count--);
}

int main()
{
    START_SL = 0;
    START_ROT = 0;
    DIR_ROT = 0;

    while (1)
    {
        START_SL = 1;

        while (FIN_SL == 0);

        START_SL = 0;

        while (FIN_SL == 1);

        delay(500); // à ajuster ... 
    }

    return 0;
}