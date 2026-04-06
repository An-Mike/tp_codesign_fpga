## Étape 6 — Gestion des aller-retours

### Objectif
Dans cette dernière partie nous utilisons le NIOS comme superviseur. 

### Réalisation
- Nous avons créé un automate en C permettant de basculer entre mode suivi_ligne et rotation. 
Notre programme c est trouvable sous le nom : **v6/pogram/main.c**
- L'automate fonctionne de la manière suivante : 
    - A l'initialisation, le robot reste à l'arrêt tant qu'il ne détecte pas la ligne
    - Dès qu'il détecte la ligne, il passe en mode suivi de ligne et y reste tant que fin_SL=0
    - Quand fin_SL=1, il s'arrete pendant 1 seconde puis passe en mode rotation. Il y reste tant que fin_rot=0 puis s'arrete à nouveau 1 seconde avant de repasser en mode suivi de ligne

### Tests réalisés pour la validation: 
#### aller-retours sur une ligne droite
Nous avons dans un premier temps valider l'automate sur une ligne droite

#### BONUS : tour complet
Nous avons ensuite effectué un tour complet sur un circuit fermé. Pour cela certain paramètres ont dû être ajustés. Nous avons diminué le gain proportionnel pour que la correction ne se fasse pas de manière trop brutale sur les virages. nous avons également diminué les vitesses de bases des roues.


