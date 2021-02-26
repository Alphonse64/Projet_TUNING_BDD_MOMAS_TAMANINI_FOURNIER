OPTIONS(SKIP = 1, ERRORS = 100000)
LOAD DATA
INFILE '../../Data/Immatriculations.csv'
INSERT INTO TABLE immatriculation
FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(immatriculation, marque, nom, puissance, longueur, nbPlaces, nbPortes, couleur, occasion, prix)
