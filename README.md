## Étape 5 — Gestion de la rotation 

### Objectif
implémenter le bloc 5(automate permettant au robot de tourner sur place lorsqu'il perdra la ligne noire)

### Réalisation
- L'automate que nous avons implémenté est trouvable sous le nom de **v5/rotation.vhd**
- Il attend que le signal start_rot passe à 1 pour démarrer la rotation
- La direction est définie par dir_rot (0 pour une rotation vers la droite et 1 vers la gauche)
- Lorsque la ligne est retrouvée, fin_rot passe à 1

### Tests réalisés pour la validation: 
Nous avons lancé l'automate de rotation lorsqu'on voit plus la ligne noire.
start_rot est controlable par SW[0], dir_rot par SW[1]. Aussi, tous les signaux (start_rot, dir_rot, fin_rot) sont visibles sur les leds.

