#include <stdint.h>

// Définition des adresses mémoire
#define START_ROT  (*(volatile uint32_t*)0x04003030)
#define DIR_ROT    (*(volatile uint32_t*)0x04003020)

int main()
{
    // Choix de direction
    DIR_ROT = 0;   

    // Lancer la rotation
    START_ROT = 1;

    while (1)
    {
        // boucle infinie
    }

    return 0;
}