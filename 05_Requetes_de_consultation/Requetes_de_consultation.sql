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


-- Voir l'age des clients et la marque des voitures prise pour les voitures puissates (>150)
SELECT DISTINCT immatriculation.puissance, immatriculation.marque
FROM immatriculation
JOIN catalogue 
ON immatriculation.marque = catalogue.marque
JOIN client 
ON immatriculation.immatriculation = client.immatriculation
WHERE immatriculation.puissance > 150
ORDER BY client.age DESC;



-- REQUETES PLUS DE 3 TABLES

