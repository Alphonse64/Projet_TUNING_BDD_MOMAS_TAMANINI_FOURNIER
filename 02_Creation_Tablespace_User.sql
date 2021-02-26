-- Creation du TableSpace

connect sys as sysdba

CREATE TABLESPACE Projet_TUNING DATAFILE '%ORACLE_BASE%\oradata\&MYINSTANCE\&DBALIAS\Projet_TUNING.DBF' SIZE 200M AUTOEXTEND on next 50M
    EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO;

-- Se connecter avec votre compte CDB dans la PDB pour créer l'utilisateur 
-- &MYPDBUSER
connect &MYCDBUSER@&DBALIASPDB/&MYCDBUSERPASS

-- suprimer l'utilisateur s'il existe déjà
drop user &MYPDBUSER cascade;

-- Création de l'utilisateur. 
create user &MYPDBUSER identified by &MYPDBUSERPASS
default tablespace Projet_TUNING
temporary tablespace temp;

-- affecter et enlever des droits
grant dba to &MYPDBUSER;

revoke unlimited tablespace from &MYPDBUSER;

alter user &MYPDBUSER quota unlimited on users;

-- Connexion avec le nouvel utilisateur ou un utilisateur existant au niveau
-- PDB. 
connect &MYPDBUSER@&DBALIASPDB/&MYPDBUSERPASS

