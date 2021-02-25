-- Import data catalogue

LOAD DATA
INFILE 'C:\GitHub\Projet_TUNING_BDD_MOMAS_TAMANIN_FOURNIER\Data\Catalogue.csv'
INTO TABLE Catalogue
FIELDS TERMINATED BY ','
(marque, nom, puissance, longueur, nbPlaces, nbPortes, couleur, occasion, prix)