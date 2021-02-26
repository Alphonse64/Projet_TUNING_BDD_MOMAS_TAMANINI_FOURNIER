

cmd
-- Lancer sqlplus sans se logger
sqlplus /nolog


-- D�finir la variable contenant le nom de l'instance
define MYINSTANCE=orcl

-- D�finir la vairiable qui va contenir le nom r�seau de votre base PDB.
-- Le nom r�seau se trouve dans le fichier tnsnames.ora
-- Il est disponible dans le dossier : %ORACLE_HOME%\network\admin
define DBALIASPDB=ORCLPDB1

-- D�finir la vairiable qui va contenir le nom r�seau de votre base CDB.
-- Le nom r�seau se dans le fichier tnsnames.ora
-- Il est disponible dans le dossier : %ORACLE_HOME%\network\admin
define DBALIASCDB=orcl

-- D�finir la variable contenant le nom de l'utilisateur que vous allez 
-- utiliser au niveau CDB. 
define MYCDBUSER=SYSTEM
 
-- D�finir la variable contenant le pass de l'utilisateur que vous allez 
-- utiliser au niveau CDB.
define MYCDBUSERPASS=Dbamanager1

-- D�finir la variable contenant le nom de l'utilisateur que vous allez 
-- cr�er au niveau PDB ou utiliser s'il existe d�j�. 
define MYPDBUSER=Projet_TUNING_BDD_MOMAS_TAMANINI_FOURNIER
 
-- D�finir la variable contenant le pass de l'utilisateur que vous allez 
-- cr�er au niveau PDB ou utiliser s'il existe d�j�.
define MYPDBUSERPASS=PassOrs2

-- D�finir la variable contenant la trace que vous souhaitez :
-- ON : si affiche r�sultat+plan
-- TRACEONLY : si affichage plan uniquement
-- define TRACEOPTION=TRACEONLY

-- Connexion avec le nouvel utilisateur ou un utilisateur existant au niveau
-- PDB. 
connect &MYPDBUSER@&DBALIASPDB/&MYPDBUSERPASS

---------------------------------------------------------------------------------------
-- 2. activation du script pour ex�cuter le conseiller SAA
-- Le r�sultat de cette ex�cution sera la g�n�ration dans le dossier :
-- %ORACLE_BASE%\admin\dpdump\nomBase\nomPdb
-- d'un fichier nomm� : SAA_Generate_script_on_bank_app_'||mydate||'.sql
@&PROJECTPATH\07_access_advisor\02_ACTIVITY.SQL

-- 3 Impl�mentation des recommandations
-- Copier le contenu du fichier g�n�r� en 2 dans le dossier fichier :
-- Ex101_Tune2_SAA_BANK_3Recommandations.sql
-- Ce fichier se trouve dans le dossier :&SCRIPTPATH\EXO101
-- Nettoyer les doublons puis ex�cutez ce script pour impl�menter les recommandations
@&PROJECTPATH\07_access_advisor\03_Recommandations.sql


-- 4. activation du script pour r�ex�cuter le conseiller SAA
-- Le r�sultat de cette r�ex�cution sera la g�n�ration dans le dossier :
-- %ORACLE_BASE%\admin\dpdump\nomBase\nomPdb
-- d'un fichier nomm� : SAA_Generate_script_on_bank_app_'||mydate||'.sql
-- Si l'�tape 3 est faite il ne doit pas avoir de recommandationn d'index
@&PROJECTPATH\07_access_advisor\04_ActivityRetune.SQL


