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

SELECT DISTINCT immatriculation.puissance, immatriculation.marque
FROM immatriculation
JOIN catalogue 
ON immatriculation.marque = catalogue.marque
JOIN client 
ON immatriculation.immatriculation = client.immatriculation
WHERE immatriculation.puissance > 150
ORDER BY client.age DESC;


-- Voir la marque des voitures avec une puissante >150
SELECT DISTINCT immatriculation.puissance, immatriculation.marque
FROM immatriculation
JOIN catalogue 
ON immatriculation.marque = catalogue.marque
JOIN client 
ON immatriculation.immatriculation = client.immatriculation
WHERE immatriculation.puissance > 150 
ORDER BY immatriculation.puissance  DESC;


-- REQUETES PLUS DE 3 TABLES

--Selectionner l'age de tous les conducteurs de Dacia.
SELECT DISTINCT marketing.age
FROM marketing
JOIN client
ON client.sexe = marketing.sexe
JOIN immatriculation
ON client.immatriculation=immatriculation.immatriculation 
JOIN catalogue
ON catalogue.puissance=immatriculation.puissance
WHERE immatriculation.marque='Dacia'
ORDER BY marketing.age DESC;

--Couleur de la voiture de tous les clients de la table marketing qui ont moins de 2 enfants.
SELECT DISTINCT catalogue.couleur
FROM catalogue
JOIN immatriculation
ON catalogue.puissance=immatriculation.puissance
JOIN client
ON client.immatriculation=immatriculation.immatriculation
JOIN marketing
ON client.sexe = marketing.sexe
WHERE marketing.nbEnfantsAcharge<2;


--Afficher l'id, le taux et la situation familiale des clients qui poss�dent une Dacia.
SELECT DISTINCT  marketing.clientMarketingId, marketing.taux, marketing.situationFamiliale
FROM marketing
JOIN client
ON client.sexe = marketing.sexe
JOIN immatriculation
ON client.immatriculation=immatriculation.immatriculation 
JOIN catalogue
ON catalogue.puissance=immatriculation.puissance
WHERE immatriculation.marque='Dacia'
ORDER BY marketing.clientMarketingId DESC;

-- Selectionner la marque de voiture que prend les clients qui ont comme situation familiale "En Couple".
SELECT DISTINCT immatriculation.marque
FROM immatriculation
JOIN catalogue
ON immatriculation.marque = catalogue.marque
JOIN client
ON immatriculation.immatriculation = client.immatriculation
JOIN marketing
ON client.age = marketing.age
WHERE marketing.situationFamiliale = 'En Couple';

--Afficher l'id du client, la marque et le prix du vehicule des clients de sexe f�minin de la table marketing.
SELECT DISTINCT client.clientId, catalogue.marque, catalogue.prix
FROM catalogue
JOIN immatriculation
ON catalogue.puissance=immatriculation.puissance
JOIN client
ON client.immatriculation=immatriculation.immatriculation
JOIN marketing
ON client.sexe = marketing.sexe
WHERE marketing.sexe='F';



