-- REQUETES 1 TABLE

-- Compter le nombre d'immatriculations 
select count(*) from immatriculation;

-- Sélectionner tous les véhicules bleus du catalogue
select * from catalogue
WHERE couleur = 'bleu';

-- Sélectionner les clients de plus de 50 ans
select * from client
WHERE age > 50;

-- Sélectionner l'âge et le sexe des personnes qui souhaitent s'acheter une deuxième voiture
select age, sexe from marketing
WHERE deuxiemeVoiture = 'true';

-- Sélectionner le nom et le numéro d'immatriculation des voitures de la marque Audi
select nom, immatriculation from immatriculation
WHERE marque = 'Audi';


-- REQUETES 2 TABLES

-- Sélectionner les véhicules du catalogue qui ont déjà été immatriculés en tant que véhicules d'occasion
SELECT *
FROM catalogue 
JOIN immatriculation
ON catalogue.marque = immatriculation.marque
WHERE immatriculation.occasion = 'VRAI';

-- Sélectionner les clients qui ont le même taux que les potentiels client qui veulent acheter une deuxième voiture
SELECT *
FROM client
JOIN marketing
ON client.taux = marketing.taux
WHERE marketing.deuxiemeVoiture = 'true';

-- Sélectionner les clients qui ont déjà possédé une Audi
SELECT *
FROM client 
JOIN immatriculation
ON client.immatriculation = immatriculation.immatriculation
WHERE immatriculation.marque = 'Audi';

-- Sélectionner la couleur des voitures vendues à des femmes
SELECT couleur
FROM immatriculation
JOIN client
ON immatriculation.immatriculation = client.immatriculation
WHERE client.sexe = 'F';

-- Sélcetionner le numéro d'immatriculation des voitures dont le modèle est Laguna 2.0T
SELECT immatriculation
FROM immatriculation
JOIN catalogue
ON catalogue.nom = immatriculation.nom
WHERE catalogue.nom='Laguna 2.0T';


-- REQUETES 3 TABLES

SELECT DISTINCT marketing.taux
FROM marketing
JOIN client
ON client.sexe = marketing.sexe
JOIN immatriculation
ON immatriculation.immatriculation = client.immatriculation
WHERE immatriculation.marque = 'Audi';

SELECT DISTINCT catalogue.couleur
FROM catalogue
JOIN immatriculation
ON  immatriculation.nom = catalogue.nom
JOIN client
ON client.immatriculation = immatriculation.immatriculation
WHERE client.sexe='M';

SELECT  DISTINCT client.age
FROM client
JOIN immatriculation
ON client.immatriculation=immatriculation.immatriculation 
JOIN catalogue
ON catalogue.marque=immatriculation.marque
WHERE catalogue.couleur = 'rouge';

SELECT DISTINCT marketing.nbEnfantsAcharge
FROM marketing
JOIN client
ON client.sexe = marketing.sexe







-- REQUETES 3 TABLES OU PLUS