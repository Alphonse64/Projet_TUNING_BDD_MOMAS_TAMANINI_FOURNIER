Rem  SQL Access Advisor : Version 19.0.0.0.0 - Production
Rem  
Rem  Nom utilisateur :    PROJET_TUNING
Rem  Tâche :             TASKPROJET_TUNING
Rem  Date d''exécution :   
Rem  

CREATE INDEX "PROJET_TUNING"."IMMATRICULATION_IDX$$_005B0000"
    ON "PROJET_TUNING"."IMMATRICULATION"
    ("NOM","IMMATRICULATION")
    COMPUTE STATISTICS;

CREATE INDEX "PROJET_TUNING"."CATALOGUE_IDX$$_005B0001"
    ON "PROJET_TUNING"."CATALOGUE"
    ("NOM","COULEUR")
    COMPUTE STATISTICS;

CREATE INDEX "PROJET_TUNING"."MARKETING_IDX$$_005B0002"
    ON "PROJET_TUNING"."MARKETING"
    ("DEUXIEMEVOITURE")
    COMPUTE STATISTICS;

CREATE INDEX "PROJET_TUNING"."CLIENT_IDX$$_005B0003"
    ON "PROJET_TUNING"."CLIENT"
    ("TAUX")
    COMPUTE STATISTICS;

