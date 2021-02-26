-- 
set MYPDBUSER=Projet_TUNING_BDD_MOMAS_TAMANINI_FOURNIER
set DBALIASPDB=ORCLPDB1
set MYPDBUSERPASS=PassOrs2

-- Import des données dans la table catalogue depuis catalogue.csv via sqlloader (Dans un invite de commandes)
sqlldr userid=%MYPDBUSER%@%DBALIASPDB%/%MYPDBUSERPASS% control=control.ctl log=track.log
