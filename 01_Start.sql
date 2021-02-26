
cmd
-- Lancer sqlplus sans se logger
sqlplus /nolog


--Lisa
define MYINSTANCE=PBEST21
define DBALIASPDB=pdbest21
define DBALIASCDB=pbest21
define MYCDBUSER=SYSTEM
define MYCDBUSERPASS=DBAManager1
define MYPDBUSER=Projet_TUNING_BDD_MOMAS_TAMANINI_FOURNIER
define MYPDBUSERPASS=PassOrs2

-- Définir la variable contenant le nom de l'instance
define MYINSTANCE=orcl



-- Définir la vairiable qui va contenir le nom réseau de votre base PDB.
-- Le nom réseau se trouve dans le fichier tnsnames.ora
-- Il est disponible dans le dossier : %ORACLE_HOME%\network\admin
define DBALIASPDB=ORCLPDB1




-- Définir la vairiable qui va contenir le nom réseau de votre base CDB.
-- Le nom réseau se dans le fichier tnsnames.ora
-- Il est disponible dans le dossier : %ORACLE_HOME%\network\admin
define DBALIASCDB=orcl

-- Définir la variable contenant le nom de l'utilisateur que vous allez 
-- utiliser au niveau CDB. 
define MYCDBUSER=SYSTEM
 
-- Définir la variable contenant le pass de l'utilisateur que vous allez 
-- utiliser au niveau CDB.
define MYCDBUSERPASS=Dbamanager1

-- Définir la variable contenant le nom de l'utilisateur que vous allez 
-- créer au niveau PDB ou utiliser s'il existe déjà. 
define MYPDBUSER=Projet_TUNING_BDD_MOMAS_TAMANINI_FOURNIER
 
-- Définir la variable contenant le pass de l'utilisateur que vous allez 
-- créer au niveau PDB ou utiliser s'il existe déjà.
define MYPDBUSERPASS=PassOrs2

-- Définir la variable contenant la trace que vous souhaitez :
-- ON : si affiche résultat+plan
-- TRACEONLY : si affichage plan uniquement
-- define TRACEOPTION=TRACEONLY



-- La suite se trouve dans le fichier 02_Creation_Tablespace_User.sql




