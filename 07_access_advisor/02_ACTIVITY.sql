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

-- Sélectionner le nom et le numéro d'immatriculation des voitures de la marque Audi
INSERT INTO user_workload (username, module, action, priority, sql_text)
VALUES ('&MYPDBUSER', 'Example1', 'Action', 2,
' select nom, immatriculation from immatriculation
WHERE marque = ''Audi''')
/
 
-- Sélectionner les clients de plus de 50 ans
 INSERT INTO user_workload (username, module, action, priority, sql_text)
VALUES ('&MYPDBUSER', 'Example2', 'Action', 2,
' select * from client
WHERE age > 50');
 
-- Sélectionner les véhicules du catalogue qui ont déjà été immatriculés en tant que véhicules d'occasion
INSERT INTO user_workload (username, module, action, priority, sql_text)
VALUES ('&MYPDBUSER', 'Example3', 'Action', 2,
' SELECT *
FROM catalogue 
JOIN immatriculation
ON catalogue.marque = immatriculation.marque
WHERE immatriculation.occasion = ''VRAI''');
 
-- Sélectionner la couleur des Golf 2.0 FSI vendues à des hommes
 INSERT INTO user_workload (username, module, action, priority, sql_text)
 VALUES ('&MYPDBUSER', 'Example4', 'Action', 2,
' SELECT DISTINCT catalogue.couleur
FROM catalogue
JOIN immatriculation
ON  immatriculation.nom = catalogue.nom
JOIN client
ON client.immatriculation = immatriculation.immatriculation
WHERE client.sexe=''M'' AND catalogue.nom = ''Golf 2.0 FSI''');

-- Sélectionner les clients qui ont le même taux que les potentiels client qui veulent acheter une deuxième voiture
 INSERT INTO user_workload (username, module, action, priority, sql_text)
 VALUES ('&MYPDBUSER', 'Example5', 'Action', 2,
' SELECT *
FROM client
JOIN marketing
ON client.taux = marketing.taux
WHERE marketing.deuxiemeVoiture = ''true''');
 
-- Sélectionner le numéro d'immatriculation des voitures dont le modèle est Laguna 2.0T
 INSERT INTO user_workload (username, module, action, priority, sql_text)
 VALUES ('&MYPDBUSER', 'Example6', 'Action', 2,
' SELECT immatriculation
FROM immatriculation
JOIN catalogue
ON catalogue.nom = immatriculation.nom
WHERE catalogue.nom=''Laguna 2.0T''');

-- Sélectionner l'âge des clients ayant acheté une voiture rouge
INSERT INTO user_workload (username, module, action, priority, sql_text)
 VALUES ('&MYPDBUSER', 'Example7', 'Action', 2,
' SELECT  DISTINCT client.age
FROM client
JOIN immatriculation
ON client.immatriculation=immatriculation.immatriculation 
JOIN catalogue
ON catalogue.marque=immatriculation.marque
WHERE catalogue.couleur = ''rouge''');
 
-- Sélectionner la puissance et la marque des véhicules de plus de 150CV vendus, triés par l'âge décroissant de leur acheteur
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
execute DBMS_ADVISOR.DELETE_TASK ('TASK'||'&MYPDBUSER');
declare
saved_stmts NUMBER;
failed_stmts NUMBER;
wkld_name VARCHAR2(30) :='WKLD'||'&MYPDBUSER';
taskname VARCHAR2(30) := 'TASK'||'&MYPDBUSER'; 
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
Where workload_name= 'WKLD'||'&MYPDBUSER'
order by sql_id;


-- Visualisation des recommandations
-- Affiche du nr de recommandation, le rang et le b�n�fice de 
-- la recommandation

SELECT REC_ID, RANK, BENEFIT, type
FROM USER_ADVISOR_RECOMMENDATIONS WHERE TASK_NAME = 'TASK'||'&MYPDBUSER';

-- Visualisation des recommandations
-- Afficher des recommandations et des b�n�fices 
-- par requ�tes

SELECT sql_id, rec_id, precost, postcost,
(precost-postcost)*100/precost AS percent_benefit
FROM USER_ADVISOR_SQLA_WK_STMTS
WHERE TASK_NAME = 'TASK'||'&MYPDBUSER'
AND workload_name = 'WKLD'||'&MYPDBUSER';

-- Visualisation des recommandations
-- Affichage des actions recommand�s :
-- Comptage des actions recommand�es


SELECT 'Action Count', COUNT(DISTINCT action_id) cnt
FROM user_advisor_actions 
WHERE task_name = 'TASK'||'&MYPDBUSER';



-- Visualisation des recommandations
-- Affichage des actions recommand�s :
-- Liste des actions recommand�es


Col command format A30
Col attr1 format A40
Set long 500
SELECT rec_id, action_id, command, attr1
FROM user_advisor_actions 
WHERE task_name = 'TASK'||'&MYPDBUSER'
ORDER BY rec_id, action_id;


-- Visualisation des recommandations
-- G�n�ration des scripts SQL
-- Afin d'impl�menter les recommandations il est possible de 
-- g�n�rer des scripts

-- La fonction GET_TASK_SCRIPT construire le script
set serveroutput on
begin
dbms_output.put_line(DBMS_ADVISOR.GET_TASK_SCRIPT('TASK'||'&MYPDBUSER'));
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
buffer=>DBMS_ADVISOR.GET_TASK_SCRIPT('TASK'||'&MYPDBUSER'),
location =>'DATA_PUMP_DIR', 
 filename=>fname
);
end;
/

spool off