-- CREATION TABLESPACE ET USER

cmd
-- Lancer sqlplus sans se logger
sqlplus /nolog

-- Définir la vairiable qui va contenir le nom réseau de votre base.
-- Le nom réseau se dans le fichier tnsnames.ora
-- Il est disponible dans le dossier : %ORACLE_HOME%\network\admin
define DBALIAS=ORCLPDB1

	
-- Définir la variable contenant le nom de l'utilisateur que vous allez créer

define MYUSER=Projet_TUNING_BDD_MOMAS_TAMANINI_FOURNIER

-- Définir la variable contenant le password du compte SYSTEM
define SYSTEMPASSWORD=Dbamanager1

-- 
define MYINSTANCE=orcl

-- Création du TableSpace

connect sys as dba

CREATE TABLESPACE &MYUSER DATAFILE'%ORACLE_BASE%\oradata\&MYINSTANCE\&DBALIAS\Projet_TUNING_BDD_MOMAS_TAMANINI_FOURNIER.DBF' SIZE 1G
    EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO;

	
-- Se connecter avec votre compte System pour créer l'utilisateur 
connect system@&DBALIAS/&SYSTEMPASSWORD

