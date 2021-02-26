-- REQUETES 1 TABLE
select count(*) from immatriculation;

select * from catalogue
WHERE couleur = 'bleu';

select * from client
WHERE age > 50;

select age, sexe from marketing
WHERE deuxiemeVoiture = 'true';

select marque from immatriculation
WHERE marque = 'Audi';


-- REQUETES 2 TABLES

SELECT *
FROM catalogue 
JOIN immatriculation
ON catalogue.marque = immatriculation.marque
WHERE immatriculation.occasion = 'VRAI';

SELECT *
FROM client
JOIN marketing
ON client.taux = marketing.taux
WHERE marketing.deuxiemeVoiture = 'true';

SELECT *
FROM client 
JOIN immatriculation
ON client.immatriculation = immatriculation.immatriculation
WHERE immatriculation.marque = 'Audi';


SELECT couleur
FROM immatriculation
JOIN client
ON immatriculation.immatriculation = client.immatriculation
WHERE client.sexe = 'F';

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


--Afficher l'id, le taux et la situation familiale des clients qui possèdent une Dacia.
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

--Afficher l'id du client, la marque et le prix du vehicule des clients de sexe féminin de la table marketing.
SELECT DISTINCT client.clientId, catalogue.marque, catalogue.prix
FROM catalogue
JOIN immatriculation
ON catalogue.puissance=immatriculation.puissance
JOIN client
ON client.immatriculation=immatriculation.immatriculation
JOIN marketing
ON client.sexe = marketing.sexe
WHERE marketing.sexe='F';



