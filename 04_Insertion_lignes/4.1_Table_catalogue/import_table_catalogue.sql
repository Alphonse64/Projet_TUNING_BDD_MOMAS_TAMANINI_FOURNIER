-- 
set MYPDBUSER=PROJET_TUNING
set DBALIASPDB=PDBESTIATEST
set MYPDBUSERPASS=PassOrs2

-- Import des données dans la table catalogue depuis catalogue.csv via sqlloader (Dans un invite de commandes)
sqlldr userid=%MYPDBUSER%@%DBALIASPDB%/%MYPDBUSERPASS% control=control.ctl log=track.log
