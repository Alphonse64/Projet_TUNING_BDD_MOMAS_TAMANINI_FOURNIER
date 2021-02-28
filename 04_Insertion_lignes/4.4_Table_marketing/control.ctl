OPTIONS(SKIP = 1, ERRORS = 100000)
LOAD DATA
INFILE '../../Data/Marketing.csv'
INSERT INTO TABLE marketing
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
( age, sexe, taux, situationFamiliale, nbEnfantsAcharge, deuxiemeVoiture )