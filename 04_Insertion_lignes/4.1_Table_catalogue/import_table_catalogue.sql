set MYPDBUSER=PROJET_TUNING
set DBALIASPDB=ORCLPDB1
set MYPDBUSERPASS=PassOrs2
set PROJECTPATH=C:\Projet_TUNING_BDD_MOMAS_TAMANINI_FOURNIER

cd %PROJECTPATH%\04_Insertion_lignes\4.1_Table_catalogue

-- Import des données dans la table catalogue depuis catalogue.csv via sqlloader (Dans un invite de commandes)
sqlldr userid=%MYPDBUSER%@%DBALIASPDB%/%MYPDBUSERPASS% control=control.ctl log=track.log
