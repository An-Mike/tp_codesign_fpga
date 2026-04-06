## Étape 4 — Suivi de ligne

### Objectif
implémenter le bloc 4(automate permettant au robot de suivre une ligne noire)

### Réalisation
- le bloc 4 que nous avons implémenté est trouvable sous le nom : **v4/suivi_ligne.vhd**
- Il attend que le signal start_SL passe à 1 pour effectuer le suivi de ligne.
- les commandes PWM sur les 2 moteurs se fait de la manière suivante : 
    pwm_d := CONST_PWM + bias;
    pwm_g := CONST_PWM - bias;
    tel que : bias <= pos_ligne * GAIN;
    avec : GAIN = 256 
- en l'absense de ligne, le robot s'arrete et fin_SL est mis à 1

### Tests réalisés : 
Nous avons effectué un suivi de ligne avec start_SL pouvant être mis à 0 ou à 1 à l'aide d'un switch et les signaux fin_SL et start_SL étant affichés sur les leds.

