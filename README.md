## Étape 2 — Caractérisation des moteurs 

NB : notre robot a le numéro de série : 16070009-0177

### Objectif
implémenter le bloc 2 de l'architecture(controleur moteurs), l'interfacer avec le bloc 1(processeur NIOS)

### Réalisation
- Nous avons créé deux PIO MOTOR_LEFT et MOTOR_RIGHT pour envoyer les consignes de vitesse et de sens depuis le processeur NIOS vers le controleur moteur. 

- pour trouver les consignes de vitesse minimales à envoyer au controleur moteur, nous avons procédé comme suit (nous avons écrit les consignes de vitesse directement en mémoire sans passer par un programme C): 
    - etape 1 : écriture de la valeur minimale (0x2000 pour la marche avant et 0x3000 pour la marche arrière)
    - etape 2 : augmentation progressive jusqu'à ce que la roue commence à tourner
    - NB : les vitesses minimales pour chaque roue ont été évaluées en l'air et au sol, avec et sans piles.

### Résultat
La caractéristation des moteurs est présentée en page 1 du fichier excel **caractéristation des éléments du robot.xlsx**