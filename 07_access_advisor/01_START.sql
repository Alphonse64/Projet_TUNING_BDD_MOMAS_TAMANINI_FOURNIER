define PROJECTPATH=C:\Projet_TUNING_BDD_MOMAS_TAMANINI_FOURNIER

@&PROJECTPATH\01_START.sql

-- 2. activation du script pour ex�cuter le conseiller SAA
@&PROJECTPATH\07_access_advisor\02_ACTIVITY.SQL

-- 3 Impl�mentation des recommandations
@&PROJECTPATH\07_access_advisor\03_Recommandations.sql


-- 4. activation du script pour r�ex�cuter le conseiller SAA
@&PROJECTPATH\07_access_advisor\04_ActivityRetune.SQL


