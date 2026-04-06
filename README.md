## Étape 3 — Calcul de la position du robot

### Objectif
implémenter le bloc 3. 

### Réalisation
- rajout des fichiers suivant dans le projet : 
    - capteurs_sol.vhd
    - capteurs_sol_seuil.vhd
    - pll_2freqs.vhd

- Nous avons ensuite effectué le seuillage des capteurs de la manière suivante : 
    - etape 1 : Pous avons implémenté une description vhdl (que nous avons mis dans **v3/temp_sensors_caracterisation.txt**) qui permet d'afficher les valeurs retournées par les capteurs en binaire sur les leds. Les switchs sont utilisés pour sélectionné le capteur voulu (par exemple si switchs = 101 alors c'est la valeur retournée par le capteur n°05 qui est indiquée en binaire sur les leds)
    - etape 2 : Pour chaque capteur, nous avons prélevé 5 valeurs de noir et 5 valeurs de blanc 
    - etape 3 : Nous avons effectué la moyenne des blancs et des noirs vues par chaque capteurs. Ensuite, nous avons pris le max de tout les valeurs de blanc et le min de tout les valeurs de noir, puis nous avons calculé la moyenne de ces deux valeurs. Nous avons alors trouvé une valeur de 105 approximativement, soit en hexadecimal 0x69.
    - NB : les détails de la caractérisation sont trouvable en **page 2** du document **caractéristation des éléments du robot.xlsx**
    
- Nous avons implémenté **v3/calcul_position.vhd** qui permet de calculer la position de la ligne selon la formule **pos_ligne <= PPU + PDU - 6**. Ainsi nous obtenons une valeur de pos_ligne allant de -6 à +6 

