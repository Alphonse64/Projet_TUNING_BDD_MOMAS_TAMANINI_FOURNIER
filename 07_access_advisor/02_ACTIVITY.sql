/*

Exercice 101

Travail � faire via l'API

Ecrire un script qui permet d'analyser et produire des recommandations d'indexes 
et/ou de vues mat�rialis�es sur des requ�tes SQL stock�es dans une table utilisateur. 
Vous devez pour cela :
 - D�finir une t�che avec un template OLTP ou DWH ou mixte
 - D�finir un workload � partir d'une table Utilisateur (voir Annexe 11.1) � cr�er 
   � remplir avec au moins deux requ�tes
 - Attacher la t�che aux workload
 - Fixer certains param�tres de la t�che tel que 
EXECUTION_TYPE = INDEX_ONLY puis FULL
MODE = COMPREHENSIVE
- Ex�cuter la t�che

Visualiser les recommandations Et si possible accepter les recommandations

Les principales �tapes du script sont:

1. Supprimer les indexes recommand�s dans EXO91 et pos�s dans EXO91_TUNED
2. Charger les requ�tes dans la table utilisateur user_workload
3. Analyser les requ�tes et produire les recommandations
4. Consulter les recommandations

*/


set autotrace off
set termout on
set echo on
set serveroutput on


spool &PROJECTPATH\07_access_advisor\LOG\SAA_PROJECT.LOG


--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
-- 2. Charger les requ�tes dans la table utilisateur user_workload
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

-- Si utile Suppession puis cr�ation de la table utilisateur
drop table user_workload;


create table user_workload(
MODULE VARCHAR2(64) , 	--Nom du module applicatif.
ACTION VARCHAR2(64),	-- Action sur l'application.
BUFFER_GETS NUMBER default 0, --nbre total de buffer-gets pour la requ�te.
CPU_TIME NUMBER default 0, -- Total CPU time in seconds for the statement.
ELAPSED_TIME NUMBER default 0, -- Total elapsed time in seconds for the statement.
DISK_READS NUMBER default 0 , --Total number of disk-read operations used 
				-- by the statement.
ROWS_PROCESSED NUMBER default 0, --  Total number of rows process by this 
				-- SQL statement.
EXECUTIONS NUMBER default 1, -- Total number of times the statement is executed.
OPTIMIZER_COST NUMBER default  0, -- Optimizer's calculated cost value for 
				          -- executing the query.
LAST_EXECUTION_DATE DATE  default SYSDATE , -- Last time the query is 
				-- used. Defaults to not available.
PRIORITY NUMBER default 2, 	--  Must be one of the following values:
				-- 1- HIGH, 2- MEDIUM, or 3- LOW
SQL_TEXT CLOB,		--  or LONG or VARCHAR2
				-- None The SQL statement. This is a required 			-- column.
STAT_PERIOD NUMBER default 1 ,
-- Period of time that corresponds to the execution statistics in seconds.
USERNAME VARCHAR(30) default user
--Current user User submitting the query. This is a required column.
);



-- chargement des requ�tes dans cette table
-- aggregation with selection

INSERT INTO user_workload (username, module, action, priority, sql_text)
VALUES ('&MYPDBUSER', 'Example1', 'Action', 2,
' select nom, immatriculation from immatriculation
WHERE marque = 'Audi'')
/
 
 -- liste des comptes et clients dont le solde est n�gatif
 INSERT INTO user_workload (username, module, action, priority, sql_text)
VALUES ('&MYPDBUSER', 'Example2', 'Action', 2,
' select * from client
WHERE age > 50');
 
 
-- liste des transactions par compte 

-- liste des transactions par compte et client
INSERT INTO user_workload (username, module, action, priority, sql_text)
VALUES ('&MYPDBUSER', 'Example3', 'Action', 2,
' SELECT *
FROM catalogue 
JOIN immatriculation
ON catalogue.marque = immatriculation.marque
WHERE immatriculation.occasion = 'VRAI'');
 
 
 -- liste des transactions par compte et client pour lesquels le solde du compte n�gatif
 INSERT INTO user_workload (username, module, action, priority, sql_text)
 VALUES ('&MYPDBUSER', 'Example4', 'Action', 2,
' SELECT DISTINCT catalogue.couleur
FROM catalogue
JOIN immatriculation
ON  immatriculation.nom = catalogue.nom
JOIN client
ON client.immatriculation = immatriculation.immatriculation
WHERE client.sexe='M'');

-- liste des transactions par compte et client connaissant le nom du client
 INSERT INTO user_workload (username, module, action, priority, sql_text)
 VALUES ('&MYPDBUSER', 'Example5', 'Action', 2,
' SELECT *
FROM client
JOIN marketing
ON client.taux = marketing.taux
WHERE marketing.deuxiemeVoiture = 'true'');
 
 -- liste des transactions par compte et client connaissant le nom du client et op�r�es � une date donn�e
 INSERT INTO user_workload (username, module, action, priority, sql_text)
 VALUES ('&MYPDBUSER', 'Example6', 'Action', 2,
' SELECT immatriculation
FROM immatriculation
JOIN catalogue
ON catalogue.nom = immatriculation.nom
WHERE catalogue.nom='Laguna 2.0T'');

 -- 7�me requ�te
 -- liste des op�ration d'un client donn�es de type DEBIT
INSERT INTO user_workload (username, module, action, priority, sql_text)
 VALUES ('&MYPDBUSER', 'Example7', 'Action', 2,
' SELECT  DISTINCT client.age
FROM client
JOIN immatriculation
ON client.immatriculation=immatriculation.immatriculation 
JOIN catalogue
ON catalogue.marque=immatriculation.marque
WHERE catalogue.couleur = 'rouge'');
 
 -- Erreur 1 : total des transaction par client, par compte, par operation
INSERT INTO user_workload (username, module, action, priority, sql_text)
VALUES ('&MYPDBUSER', 'Example8', 'Action', 2,
' SELECT DISTINCT immatriculation.puissance, immatriculation.marque
FROM immatriculation
JOIN catalogue 
ON immatriculation.marque = catalogue.marque
JOIN client 
ON immatriculation.immatriculation = client.immatriculation
WHERE immatriculation.puissance > 150
ORDER BY client.age DESC');

 

commit;
--calcul des statistiques
execute dbms_stats.gather_schema_stats('&MYPDBUSER');

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
-- 3. Analyser les requ�tes et produire les recommandations
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------


-- programmation de tache Sql access advisor
set serveroutput on

-- fixer les sp�rateurs de nombre en Anglais. "," pour les d�cimaux et "." pour les groupes

-- Anglais
alter session set NLS_NUMERIC_CHARACTERS = '.,' ; 

-- Francais
-- alter session set NLS_NUMERIC_CHARACTERS = ',.'  ; 
execute DBMS_ADVISOR.DELETE_TASK ('TASK_Projet_TUNING');
declare
saved_stmts NUMBER;
failed_stmts NUMBER;
wkld_name VARCHAR2(30) :='WKLD_Projet_TUNING';
taskname VARCHAR2(30) := 'TASK_Projet_TUNING'; 
task_id NUMBER;
num_found NUMBER:=0;
Begin
-- d�tacher la tache et le workload
select count(*) into num_found 
from user_advisor_sqla_wk_map 
where task_name = taskname and workload_name = wkld_name;
IF num_found > 0 THEN
DBMS_ADVISOR.RESET_TASK (taskname);
DBMS_ADVISOR.DELETE_SQLWKLD_REF(taskname, wkld_name);
END IF;
dbms_output.put_line('Dans SQL access advisor : 1############################################');

-- suppression puis cr�ation de la t
select count(*) into num_found 
from dba_advisor_tasks 
where owner='&MYPDBUSER' and task_name=taskname;

IF num_found > 0 THEN
DBMS_ADVISOR.DELETE_TASK (taskname);
END IF;
DBMS_ADVISOR.CREATE_TASK ('SQL Access Advisor', task_id, taskname);
dbms_output.put_line('Dans SQL access advisor : 2############################################');

-- suppression et puis cr�ation du workload
select count(*) into num_found 
from user_advisor_sqlw_sum 
where workload_name = wkld_name;
IF num_found > 0 THEN
DBMS_ADVISOR.DELETE_SQLWKLD(workload_name=> wkld_name);
END IF;
DBMS_ADVISOR.CREATE_SQLWKLD (wkld_name);
dbms_output.put_line('Dans SQL access advisor : 3############################################');

-- chargement du workload
DBMS_ADVISOR.IMPORT_SQLWKLD_USER( 
workload_name=> wkld_name,import_mode=>'NEW', owner_name=>'&MYPDBUSER', 
table_name=>'USER_WORKLOAD', Saved_rows=>saved_stmts, 
Failed_rows=>failed_stmts);
dbms_output.put_line(' saved_stmts='||saved_stmts);
dbms_output.put_line(' failed_stmts='||failed_stmts);
-- Attacher le workload � une t�che
/* Link Workload to Task */
dbms_advisor.add_sqlwkld_ref(taskname,wkld_name);
dbms_output.put_line('Dans SQL access advisor : 4############################################');

--Mise � jour de param�tres de la t�che
dbms_advisor.set_task_parameter(taskname,'EXECUTION_TYPE','INDEX_ONLY');--'FULL');--'INDEX_ONLY');
dbms_advisor.set_task_parameter(taskname,'MODE','COMPREHENSIVE');

-- ex�cuter la t�che
DBMS_ADVISOR.EXECUTE_TASK(taskname);
dbms_output.put_line('Dans SQL access advisor : 5############################################');

Exception 
When others then
dbms_output.put_line(' SQLcode='||sqlcode);
dbms_output.put_line(' SQLerrm='||sqlerrm);
End;
/
/*
*
ERREUR � la ligne 1 :
ORA-13600: erreur survenue dans Advisor
ORA-13635: La valeur indiqu�e pour le param�tre ADJUSTED_SCALEUP_GREEN_THRESH
ne peut pas �tre convertie en nombre.
ORA-06512: � "SYS.PRVT_ADVISOR", ligne 3902
ORA-06512: � "SYS.DBMS_ADVISOR", ligne 102
ORA-06512: � ligne 26
*/

-- ALTER SYSTEM SET NLS_TERRITORY=FRANCE scope=spfile;

-- si cette apparait faire les 	actions suivantes 
-- Ne pas lancer les deux programmes qui suivent 
-- si pas d'erreur

/*
-- ne pas ex�cuter ce script si pas d'erreur plus haut
declare
template_id NUMBER;
template_name VARCHAR2(255):= 'MY_TEMPLATE';
Begin
DBMS_ADVISOR.SET_DEFAULT_TASK_PARAMETER (
'SQL Access Advisor', 
'ADJUSTED_SCALEUP_GREEN_THRESH'  ,
'1,25' -- au lieu de 1.25
);
end;
/

-- ne pas ex�cuter ce script si pas d'erreur plus haut
declare
template_id NUMBER;
template_name VARCHAR2(255):= 'MY_TEMPLATE';
Begin
DBMS_ADVISOR.SET_DEFAULT_TASK_PARAMETER (
'SQL Access Advisor', 
'OVERALL_SCALEUP_GREEN_THRESH'  ,
'1,5' -- au lieu de 1.5
);
end;
/

*/

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
-- 4. Consulter les recommandations
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

-- Consulter les requ�tes de r�f�rence que va r�gler SAA
col WORKLOAD_NAME format a20
col SQL_TEXT format a70
set linesize 200
set pagesize 400
select WORKLOAD_NAME, sql_id, SQL_TEXT from DBA_ADVISOR_SQLW_STMTS
Where workload_name= 'WKLD_Projet_TUNING'
order by sql_id;


-- Visualisation des recommandations
-- Affiche du nr de recommandation, le rang et le b�n�fice de 
-- la recommandation

SELECT REC_ID, RANK, BENEFIT, type
FROM USER_ADVISOR_RECOMMENDATIONS WHERE TASK_NAME = 'TASK_Projet_TUNING';

-- Visualisation des recommandations
-- Afficher des recommandations et des b�n�fices 
-- par requ�tes

SELECT sql_id, rec_id, precost, postcost,
(precost-postcost)*100/precost AS percent_benefit
FROM USER_ADVISOR_SQLA_WK_STMTS
WHERE TASK_NAME = 'TASK_Projet_TUNING'
AND workload_name = 'WKLD_Projet_TUNING';

-- Visualisation des recommandations
-- Affichage des actions recommand�s :
-- Comptage des actions recommand�es


SELECT 'Action Count', COUNT(DISTINCT action_id) cnt
FROM user_advisor_actions 
WHERE task_name = 'TASK_Projet_TUNING';



-- Visualisation des recommandations
-- Affichage des actions recommand�s :
-- Liste des actions recommand�es


Col command format A30
Col attr1 format A40
Set long 500
SELECT rec_id, action_id, command, attr1
FROM user_advisor_actions 
WHERE task_name = 'TASK_Projet_TUNING'
ORDER BY rec_id, action_id;


-- Visualisation des recommandations
-- G�n�ration des scripts SQL
-- Afin d'impl�menter les recommandations il est possible de 
-- g�n�rer des scripts

-- La fonction GET_TASK_SCRIPT construire le script
set serveroutput on
begin
dbms_output.put_line(DBMS_ADVISOR.GET_TASK_SCRIPT('TASK_Projet_TUNING'));
end;
/

-- La fonction CREATE_FILE permet de cr�er le fichier 
-- contenant le script
declare 
mydate varchar2(20):=to_char(sysdate, 'DD_MM_YYYY_HH24_MI_SS');
fname varchar2(300):='SAA_Generate_script_on_Projet_TUNING_app_'||mydate||'.sql';
begin
dbms_output.put_line(fname);
DBMS_ADVISOR.CREATE_FILE(
buffer=>DBMS_ADVISOR.GET_TASK_SCRIPT('TASK_Projet_TUNING'),
location =>'DATA_PUMP_DIR', 
 filename=>fname
);
end;
/

spool off

