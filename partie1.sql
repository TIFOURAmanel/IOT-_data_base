-- Création du Tablespace parDefaut
CREATE TABLESPACE IOT_TBS 
DATAFILE 'C:\Users\thinkpad\Desktop\TP-BDD\IOT_TBS.dat' 
SIZE 100M 
AUTOEXTEND ON 
ONLINE;

-- Création du Tablespace temporaire
CREATE TEMPORARY TABLESPACE IOT_TempTBS 
TEMPFILE 'C:\Users\thinkpad\Desktop\TP-BDD\IOT_TempTBS.dat' 
SIZE 100M 
AUTOEXTEND ON;

-- Création de l'utilisateur DBAIOT
CREATE USER DBAIOT 
IDENTIFIED BY tifoura123A 
DEFAULT TABLESPACE IOT_TBS 
TEMPORARY TABLESPACE IOT_TempTBS;


-- Attribution de tous les privilèges à l'utilisateur
GRANT ALL PRIVILEGES TO DBAIOT;

