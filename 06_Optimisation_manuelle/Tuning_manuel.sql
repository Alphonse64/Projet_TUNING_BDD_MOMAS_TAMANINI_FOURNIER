--Mettre en place la trace
set autotrace traceonly

--Tuning des requetes

--Premiere requete
select * from client
WHERE age > 50;

----------------------------------------------------------------------------
| Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        | 10782 |  1526K|    69   (2)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| CLIENT | 10782 |  1526K|    69   (2)| 00:00:01 |
----------------------------------------------------------------------------

--index client.age
drop index idx_client_age;
create index idx_client_age on client(age);

select  /*+INDEX(client idx_client_age) */ * from client
WHERE age > 50;

------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name           | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                | 10052 |   431K|  3891   (1)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| CLIENT         | 10052 |   431K|  3891   (1)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN                  | IDX_CLIENT_AGE | 10052 |       |    21   (0)| 00:00:01 |
------------------------------------------------------------------------------------------------------

---EN OBSERVANT LE COUT DE LA REQUETE NOUS CONFIRMONS QUE CET INDEX N'EST PAS PERTINENT 




--Deuxieme requete
SELECT *
FROM catalogue 
JOIN immatriculation
ON catalogue.marque = immatriculation.marque
WHERE immatriculation.occasion = 'VRAI';

--------------------------------------------------------------------------------------
| Id  | Operation          | Name            | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |                 |   734K|   182M|   526   (3)| 00:00:01 |
|*  1 |  HASH JOIN         |                 |   734K|   182M|   526   (3)| 00:00:01 |
|   2 |   TABLE ACCESS FULL| CATALOGUE       |   265 | 27560 |     3   (0)| 00:00:01 |
|*  3 |   TABLE ACCESS FULL| IMMATRICULATION | 55444 |  8446K|   517   (2)| 00:00:01 |
--------------------------------------------------------------------------------------

--CREATION DES INDEX 


--index drop index idx_client_age;
drop index idx_immatriculation_occasion;
create index idx_immatriculation_occasion on immatriculation(occasion);






---------------------------------------------------------------------------------------------------------------------
| Id  | Operation                            | Name                         | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                     |                              |  1147K|   122M|  1224   (1)| 00:00:01 |
|*  1 |  HASH JOIN                           |                              |  1147K|   122M|  1224   (1)| 00:00:01 |
|   2 |   TABLE ACCESS FULL                  | CATALOGUE                    |   265 | 13780 |     3   (0)| 00:00:01 |
|   3 |   TABLE ACCESS BY INDEX ROWID BATCHED| IMMATRICULATION              | 60011 |  3516K|  1212   (1)| 00:00:01 |
|*  4 |    INDEX RANGE SCAN                  | IDX_IMMATRICULATION_OCCASION | 60011 |       |   135   (1)| 00:00:01 |
---------------------------------------------------------------------------------------------------------------------

---EN OBSERVANT LE COUT DE LA REQUETE NOUS CONFIRMONS QUE CET INDEX N'EST PAS PERTINENT 

--Troisieme requete

SELECT DISTINCT catalogue.couleur
FROM catalogue
JOIN immatriculation
ON  immatriculation.nom = catalogue.nom
JOIN client
ON client.immatriculation = immatriculation.immatriculation
WHERE client.sexe='M';

--------------------------------------------------------------------------------------------------
| Id  | Operation              | Name            | Rows  | Bytes |TempSpc| Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT       |                 |   182K|    25M|       |  6826   (1)| 00:00:01 |
|   1 |  HASH UNIQUE           |                 |   182K|    25M|    27M|  6826   (1)| 00:00:01 |
|*  2 |   HASH JOIN            |                 |   182K|    25M|       |   942   (2)| 00:00:01 |
|   3 |    TABLE ACCESS FULL   | CATALOGUE       |   265 |  6360 |       |     3   (0)| 00:00:01 |
|*  4 |    HASH JOIN           |                 | 21371 |  2525K|       |   938   (1)| 00:00:01 |
|   5 |     VIEW               | VW_DTP_3A8B9847 | 21371 |  1085K|       |   421   (1)| 00:00:01 |
|   6 |      HASH UNIQUE       |                 | 21371 |  1440K|  1688K|   421   (1)| 00:00:01 |
|*  7 |       TABLE ACCESS FULL| CLIENT          | 21371 |  1440K|       |    69   (2)| 00:00:01 |
|   8 |     TABLE ACCESS FULL  | IMMATRICULATION |   183K|    12M|       |   515   (1)| 00:00:01 |



--index drop index idx_client_sexe;
drop index idx_client_sexe;
create index idx_client_sexe on client(sexe);



SELECT  /*+INDEX(client idx_client_sexe) */ catalogue.couleur from catalogue
JOIN immatriculation
ON  immatriculation.nom = catalogue.nom
JOIN client
ON client.immatriculation = immatriculation.immatriculation
WHERE client.sexe='M';
---------------------------------------------------------------------------------------------------------
| Id  | Operation                             | Name            | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                      |                 |   191K|  9746K|   832   (1)| 00:00:01 |
|*  1 |  HASH JOIN                            |                 |   191K|  9746K|   832   (1)| 00:00:01 |
|   2 |   TABLE ACCESS FULL                   | CATALOGUE       |   265 |  4505 |     3   (0)| 00:00:01 |
|*  3 |   HASH JOIN                           |                 | 20065 |   685K|   827   (1)| 00:00:01 |
|   4 |    TABLE ACCESS BY INDEX ROWID BATCHED| CLIENT          | 20065 |   254K|   311   (1)| 00:00:01 |
|*  5 |     INDEX RANGE SCAN                  | IDX_CLIENT_SEXE | 20065 |       |    37   (0)| 00:00:01 |
|   6 |    TABLE ACCESS FULL                  | IMMATRICULATION |   197K|  4233K|   515   (1)| 00:00:01 |
---------------------------------------------------------------------------------------------------------


---SUITE AU COUT DE LA REQUETE NOUS CONFIRMONS QUE CET INDEX EST PERTINENT 


execute dbms_stats.gather_schema_stats('&MYPDBUSER');