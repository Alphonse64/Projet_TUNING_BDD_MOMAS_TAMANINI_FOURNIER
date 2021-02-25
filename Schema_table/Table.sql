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

-- suprimer l'utilisateur s'il existe déjà

drop user &MYUSER cascade;

-- Création de l'utilisateur. 

create user &MYUSER identified by PassOrs1
default tablespace Projet_TUNING
temporary tablespace temp;

-- affecter et enlever des droits
grant dba to &MYUSER;

revoke unlimited tablespace from &MYUSER;

-- Définir la variable contenant le password du compte SYSTEM
define SYSTEMPASSWORD=Dbamanager1

-- Définir la variable
define MYINSTANCE=orcl

-- Création du TableSpace

connect sys as dba

CREATE TABLESPACE Projet_TUNING DATAFILE '%ORACLE_BASE%\oradata\&MYINSTANCE\&DBALIAS\Projet_TUNING_01.DBF' SIZE 200M AUTOEXTEND on next 50M
    EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO;

	
-- Se connecter avec votre compte System pour créer l'utilisateur 
connect system@&DBALIAS/&SYSTEMPASSWORD

