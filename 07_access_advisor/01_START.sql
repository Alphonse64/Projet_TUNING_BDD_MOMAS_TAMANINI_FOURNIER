

cmd
-- Lancer sqlplus sans se logger
sqlplus /nolog


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

-- Connexion avec le nouvel utilisateur ou un utilisateur existant au niveau
-- PDB. 
connect &MYPDBUSER@&DBALIASPDB/&MYPDBUSERPASS

---------------------------------------------------------------------------------------
-- 2. activation du script pour exécuter le conseiller SAA
-- Le résultat de cette exécution sera la génération dans le dossier :
-- %ORACLE_BASE%\admin\dpdump\nomBase\nomPdb
-- d'un fichier nommé : SAA_Generate_script_on_bank_app_'||mydate||'.sql
@&PROJECTPATH\07_access_advisor\02_ACTIVITY.SQL

-- 3 Implémentation des recommandations
-- Copier le contenu du fichier généré en 2 dans le dossier fichier :
-- Ex101_Tune2_SAA_BANK_3Recommandations.sql
-- Ce fichier se trouve dans le dossier :&SCRIPTPATH\EXO101
-- Nettoyer les doublons puis exécutez ce script pour implémenter les recommandations
@&PROJECTPATH\07_access_advisor\03_Recommandations.sql


-- 4. activation du script pour réexécuter le conseiller SAA
-- Le résultat de cette réexécution sera la génération dans le dossier :
-- %ORACLE_BASE%\admin\dpdump\nomBase\nomPdb
-- d'un fichier nommé : SAA_Generate_script_on_bank_app_'||mydate||'.sql
-- Si l'étape 3 est faite il ne doit pas avoir de recommandationn d'index
@&PROJECTPATH\07_access_advisor\04_ActivityRetune.SQL


