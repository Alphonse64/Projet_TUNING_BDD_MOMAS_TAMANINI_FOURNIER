set MYPDBUSER=PROJET_TUNING
set DBALIASPDB=ORCLPDB1
set MYPDBUSERPASS=PassOrs2
set PROJECTPATH=C:\GitHub\Projet_TUNING_BDD_MOMAS_TAMANIN_FOURNIER

cd %PROJECTPATH%\04_Insertion_lignes\4.3_Table_client

-- Import des donn�es dans la table catalogue depuis catalogue.csv via sqlloader (Dans un invite de commandes)
sqlldr userid=%MYPDBUSER%@%DBALIASPDB%/%MYPDBUSERPASS% control=control.ctl log=track.log