

-- Connection en tant que DBAIOT  
connect DBAIOT/tifoura123A ;  


--Creation de user Admin
CREATE USER Admin IDENTIFIED BY manelAdminY8B 
DEFAULT TABLESPACE IOT_TBS 
TEMPORARY TABLESPACE IOT_TempTBS;

--Connexion avec Admin
CONNECT Admin/manelAdminY8B ; --ca ne va pas marcher a cause des privileges,


--Donner le droit de création d'une session à Admin
GRANT CREATE SESSION TO Admin;
CONNECT Admin/manelAdminY8B ;


--Donner des privileges a Admin 
--il faut dabord recconecter a DBAIOT
connect DBAIOT/tifoura123A ; 
GRANT CREATE TABLE, CREATE USER TO Admin;
--Verification ( il faut reconnecter a admin psk had linstruction taffichi les privileges t3 user lui meme li raho connecter)
 SELECT * FROM USER_SYS_PRIVS;

--Requete a executer 
CONNECT Admin/manelAdminY8B ;
SELECT * FROM DBAIOT.USERS;  -- Une erreur se produira car Admin n'a pas encore les privilèges de lecture sur la table USERS.


--Donner a Admin le privilege de lecture
CONNECT DBAIOT/tifoura123A ;
GRANT SELECT ON DBAIOT.USERS TO Admin;
CONNECT Admin/manelAdminY8B ;
SELECT * FROM DBAIOT.USERS;


--Creation de la vue 
CREATE VIEW USER_THING AS
SELECT U.IDUSER, U.LASTNAME, U.FIRSTNAME, T.MAC, T.THINGTYPE, T.PARAM
FROM DBAIOT.USERS U , DBAIOT.THING T
WHERE U.IDUSER = T.IDUSER;  --Une erreur apparaîtra car Admin n'a pas les privilèges de création de vue ou de lecture sur la table THING.

--Donner les privileges
CONNECT DBAIOT/tifoura123A ;
GRANT CREATE VIEW TO Admin;
GRANT SELECT ON DBAIOT.THING TO Admin;

-- Réessayez de créer la vue :
CONNECT Admin/manelAdminY8B ;
CREATE VIEW USER_THING AS
SELECT U.IDUSER, U.LASTNAME, U.FIRSTNAME, T.MAC, T.THINGTYPE, T.PARAM
FROM DBAIOT.USERS U , DBAIOT.THING T 
WHERE U.IDUSER = T.IDUSER;

--Creation dindex
CREATE INDEX NAMESERVICE_IX ON DBAIOT.SERVICE(NAME); --Une erreur apparaîtra car Admin n'a pas les droits de création d'index et na pas acces a la table service.

--Donner les privileges 
CONNECT DBAIOT/tifoura123A ;
GRANT CREATE ANY INDEX TO Admin;
GRANT SELECT ON DBAIOT.SERVICE TO Admin ;

-- Réessayez de créer l'index :
CONNECT Admin/manelAdminY8B ;
CREATE INDEX NAMESERVICE_IX ON DBAIOT.SERVICE(NAME); 


--Enlever les privileges
CONNECT DBAIOT/tifoura123A ;
REVOKE CREATE TABLE FROM Admin;
REVOKE CREATE USER FROM Admin;
REVOKE CREATE VIEW FROM Admin;
REVOKE CREATE ANY INDEX FROM Admin;
REVOKE SELECT ON USERS FROM Admin;
REVOKE SELECT ON THING FROM Admin;
REVOKE SELECT ON SERVICE FROM Admin;

--Verification
SELECT * FROM USER_TAB_PRIVS WHERE GRANTEE = 'ADMIN'; --Aucun privilège ne devrait apparaître pour Admin.
SELECT * FROM USER_SYS_PRIVS WHERE USERNAME = 'ADMIN'; --Aucun privilège ne devrait apparaître pour Admin.




--Creation de profil

   
CREATE PROFILE IOT_Profil
LIMIT 
    SESSIONS_PER_USER         3
    CPU_PER_CALL              3500
    CONNECT_TIME              90
    LOGICAL_READS_PER_CALL    1200
    PRIVATE_SGA               25K
    IDLE_TIME                 30
    FAILED_LOGIN_ATTEMPTS     5
    PASSWORD_LIFE_TIME        50
    PASSWORD_REUSE_TIME       40
    PASSWORD_REUSE_MAX        UNLIMITED
    PASSWORD_LOCK_TIME        1
    PASSWORD_GRACE_TIME       5;

--affectation du profil a admin
ALTER USER Admin PROFILE IOT_Profil;


--Création du rôle SUBSCRIBE_MANAGER
CREATE ROLE SUBSCRIBE_MANAGER;

GRANT SELECT ON DBAIOT.USERS TO SUBSCRIBE_MANAGER;
GRANT SELECT ON DBAIOT.SERVICE TO SUBSCRIBE_MANAGER;
GRANT UPDATE ON DBAIOT.SUBSCRIBE TO SUBSCRIBE_MANAGER;


--assigniationdu role a admin
GRANT SUBSCRIBE_MANAGER TO Admin;
-- Vérification des autorisations :
CONNECT Admin/manelAdminY8B ; 
SELECT * FROM ROLE_TAB_PRIVS WHERE ROLE = 'SUBSCRIBE_MANAGER';

















