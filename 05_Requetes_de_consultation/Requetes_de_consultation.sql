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
JOIN immatriculation
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

SELECT DISTINCT marketing.nbEnfantsAcharge
FROM marketing
JOIN client
ON client.sexe = marketing.sexe







-- REQUETES 3 TABLES OU PLUS