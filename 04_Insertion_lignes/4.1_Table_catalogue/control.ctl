OPTIONS (SKIP=1, ERRORS=100000)
LOAD DATA
INFILE '../../Data/Catalogue.csv'
INSERT INTO TABLE catalogue
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(marque, nom, puissance, longueur, nbPlaces, nbPortes, couleur, occasion, prix)

