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


