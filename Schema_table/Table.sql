-- CREATION DES TABLES


-- Table client : age, sexe, taux, situationFamiliale, nbEnfantsAcharge, 2eme voiture, immatriculation

Create table Clients(
	clientId NUMBER GENERATED ALWAYS AS IDENTITY constraint pk_clientId primary key,
	age	number(2) constraint chk_age_client
		check(age BETWEEN 18 AND 84),
	sexe varchar2(30) constraint chk_sexe 
		check(sexe IN ('M', 'F')),
	taux number(5) constraint chk_taux
		check(age BETWEEN 544 AND 74185),
	situationFamiliale varchar2(30)constraint chk_situation
		check(sexe IN ('Célibataire', 'Divorcée', 'En Couple', 'EnCouple', 'Marié', 'Mariée', 'Seul', 'Seule')),
	nbEnfantsAcharge number(2) constraint chk_nb_enfants
		check(nbEnfantsAcharge BETWEEN 0 AND 4),
	deuxiemeVoiture varchar2(10) constraint chk_voiture 
		check(deuxiemeVoiture IN ('true', 'false')),
	immatriculation varchar2(10) constraint chk_immat 
		CHECK (LENGTHB(immatriculation) = 10)references Immatriculations(immatriculation),
	
) ;

