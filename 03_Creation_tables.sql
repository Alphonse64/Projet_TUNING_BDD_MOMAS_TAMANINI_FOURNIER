-- CREATION DES TABLES

drop table catalogue cascade constraints;
drop table immatriculation cascade constraints;
drop table client cascade constraints;
drop table marketing cascade constraints;

-- Table Catalogue

CREATE TABLE catalogue (
	marque varchar2(15) 
        constraint chk_catalogue_marque 
		check (marque IN (
             'Audi', 'BMW', 'Dacia', 'Daihatsu', 'Fiat', 'Ford',
             'Honda', 'Hyundaï', 'Jaguar', 'Kia', 'Lancia',
             'Mercedes' , 'Mini', 'Nissan', 'Peugeot', 'Renault',
             'Saab', 'Seat', 'Skoda', 'Volkswagen','Volvo'
        )),
	nom varchar2(30) 
        constraint chk_catalogue_nom
		check(nom IN (
            'S80 T6', 'Touran 2.0 FSI', 'Polo 1.2 6V',
            'New Beatle 1.8', 'Golf 2.0 FSI', 'Superb 2.8 V6', 
            'Toledo 1.6', '9.3 1.8T', 'Vel Satis 3.5 V6',
            'Megane 2.0 16V', 'Laguna 2.0T', 
            'Espace 2.0T', '1007 1.4', 'Primera 1.6',
            'Maxima 3.0 V6', 'Almera 1.8', 'Copper 1.6 16V',
            'S500', 'A200', 'Ypsilon 1.4 16V', 'Picanto 1.1',
            'X-Type 2.5 V6', 'Matrix 1.6', 'FR-V 1.7',
            'Mondeo 1.8', 'Croma 2.2', 'Cuore 1.0', 'Logan 1.6 MPI',
            'M5', '120i', 'A3 2.0 FSI', 'A2 1.4'
        )),
	puissance number(3) 
        constraint chk_catalogue_puissance
		check(puissance BETWEEN 55 AND 507),
	longueur varchar2(20),
        --constraint chk_catalogue_longueur
		--check(longueur IN ('courte', 'moyenne', 'longue', 'très longue')),
	nbPlaces number(2) 
        constraint chk_catalogue_nb_places
		check(nbPlaces BETWEEN 5 AND 7),
	nbPortes number(2) 
        constraint chk_catalogue_nb_portes 
		check(nbPortes BETWEEN 3 AND 5),
	couleur varchar2(10) 
        constraint chk_catalogue_couleur 
        check(couleur IN ('blanc', 'bleu', 'gris', 'noir', 'rouge')),
    occasion varchar2(10) 
        constraint chk_catalogue_occasion
		check(occasion IN ('true', 'false')),
    prix number(8) 
        constraint chk_catalogue_prix
		check(prix BETWEEN 7500 AND 101300)
);


-- Table Immatriculation

CREATE TABLE immatriculation (
	immatriculation varchar2(100) 
    constraint pk_immatriculationId primary key,
    --constraint chk_immat_format 
	--CHECK (LENGTHB(immatriculation) = 10),
	marque varchar2(15) 
        constraint chk_immat_marque
		check (marque IN (
             'Audi', 'BMW', 'Dacia', 'Daihatsu', 'Fiat', 'Ford',
             'Honda', 'Hyundaï', 'Jaguar', 'Kia', 'Lancia',
             'Mercedes' , 'Mini', 'Nissan', 'Peugeot', 'Renault',
             'Saab', 'Seat', 'Skoda', 'Volkswagen','Volvo'
        )),
	nom varchar2(30) 
        constraint chk_immat_nom 
		check(nom IN (
            'S80 T6', 'Touran 2.0 FSI', 'Polo 1.2 6V',
            'New Beatle 1.8', 'Golf 2.0 FSI', 'Superb 2.8 V6', 
            'Toledo 1.6', '9.3 1.8T', 'Vel Satis 3.5 V6',
            'Megane 2.0 16V', 'Laguna 2.0T', 
            'Espace 2.0T', '1007 1.4', 'Primera 1.6',
            'Maxima 3.0 V6', 'Almera 1.8', 'Copper 1.6 16V',
            'S500', 'A200', 'Ypsilon 1.4 16V', 'Picanto 1.1',
            'X-Type 2.5 V6', 'Matrix 1.6', 'FR-V 1.7',
            'Mondeo 1.8', 'Croma 2.2', 'Cuore 1.0', 'Logan 1.6 MPI',
            'M5', '120i', 'A3 2.0 FSI', 'A2 1.4'
        )),
	puissance number(3) 
        constraint chk_immat_puissance
		check(puissance BETWEEN 55 AND 507),
	longueur varchar2(20),
        --constraint chk_immat_longueur
		--check(longueur IN ('courte', 'moyenne', 'longue', 'très longue')),
	nbPlaces number(2) 
        constraint chk_immat_nb_places
		check(nbPlaces BETWEEN 5 AND 7),
	nbPortes number(2) 
        constraint chk_immat_nb_portes 
		check(nbPortes BETWEEN 3 AND 5),
	couleur varchar2(10) 
        constraint chk_immat_couleur 
        check(couleur IN ('blanc', 'bleu', 'gris', 'noir', 'rouge')),
	occasion varchar2(10) 
        constraint chk_immat_occasion
		check(occasion IN ('VRAI', 'FAUX')),
    prix number(8) 
        constraint chk_immat_prix
		check(prix BETWEEN 7500 AND 101300)
);


-- Table client

CREATE TABLE client (
	clientId NUMBER GENERATED ALWAYS AS IDENTITY constraint pk_clientId primary key,
	age  number(2) 
        constraint chk_client_age
		check(age BETWEEN 18 AND 84),
	sexe varchar2(30) 
        constraint chk_client_sexe 
		check(sexe IN ('M', 'F')),
	taux number(8) 
        constraint chk_client_taux
		check(taux BETWEEN 544 AND 74185),
	situationFamiliale varchar2(30),
        --constraint chk_client_situation
		--check(situationFamiliale IN ('Célibataire', 'Divorcée', 'En Couple', 'EnCouple', 'Marié', 'Mariée', 'Seul', 'Seule')),
	nbEnfantsAcharge number(2) 
        constraint chk_client_nb_enfants
		check(nbEnfantsAcharge BETWEEN 0 AND 4),
	deuxiemeVoiture varchar2(10) 
        constraint chk_client_voiture 
		check(deuxiemeVoiture IN ('true', 'false')),
	immatriculation varchar2(100) 
        --constraint chk_ref_immat 
		--CHECK (LENGTHB(immatriculation) = 10) 
        references immatriculation(immatriculation)
);


-- Table Marketing

CREATE TABLE marketing (
	clientMarketingId NUMBER GENERATED ALWAYS AS IDENTITY constraint pk_clientMarketingId primary key,
	age	 number(2) 
        constraint chk_marketing_age
		check(age BETWEEN 18 AND 84),
	sexe varchar2(30) 
        constraint chk_marketing_sexe
		check(sexe IN ('M', 'F')),
	taux number(8) 
        constraint chk_marketing_taux
		check(taux BETWEEN 544 AND 74185),
	situationFamiliale varchar2(30),
        --constraint chk_marketing_situation
		--check(situationFamiliale IN ('Célibataire', 'Divorcée', 'En Couple', 'EnCouple', 'Marié', 'Mariée', 'Seul', 'Seule')),
	nbEnfantsAcharge number(2) 
        constraint chk_marketing_nb_enfants
		check(nbEnfantsAcharge BETWEEN 0 AND 4),
	deuxiemeVoiture varchar2(10) 
        constraint chk_marketing_voiture 
		check(deuxiemeVoiture IN ('true', 'false'))
);