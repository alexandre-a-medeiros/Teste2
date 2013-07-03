----------------------------------------------------------------------------
-- ATENCAO AOS COMENTARIOS "MUDAR"

connect APP_STGOWN/APP_STGOWNx#y@MIGDW

spool ServiceLogin.ini.1.LOG

SET SERVEROUTPUT ON;
SET TIME ON;
SET TIMING ON;

ALTER SESSION ENABLE PARALLEL DML;
ALTER SESSION ENABLE PARALLEL QUERY;

-- 1 - PASSO INICIAL CRIAR TABELA AUXILIAR DO SERVICO DE LOGIN PRINCIPAL IG CRM
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE APP_STGOWN.SERVICE_LOGIN_AUX_I';
EXCEPTION
	WHEN OTHERS THEN
	IF SQLCODE != -942 THEN
		RAISE;
	END IF;
END;


CREATE TABLE APP_STGOWN.SERVICE_LOGIN_AUX_I nologging compress
AS  
  SELECT   *  FROM APP_RELOWN.SERVICE  WHERE 1<>1 
  UNION
	SELECT  /*+ PARALLEL(stg,16) PARALLEL(act,16) */
		--------------------------------------
		-- 1 SRKSRV
		--------------------------------------
		app_stgown.F_SEQUENCE_SERVICE,
		--------------------------------------
		-- 2 CODSRV
		--------------------------------------
		'IG-LP' || stg.CLI_COD,		
		--------------------------------------
		-- 3 GLOSRV
		--------------------------------------
	  	'true',
		--------------------------------------
		-- 4 LGNSRV
		--------------------------------------
		stg.CLI_LOGIN,
		--------------------------------------
		-- 5 PSWSRV
		--------------------------------------
		STG.CLI_SENHA,
		--------------------------------------
		-- 6 DTECRESRV
		--------------------------------------
		TO_DATE(stg.CLI_DATACAD,'YYYYMMDDHH24MISS'),
		--------------------------------------
		-- 7 DTEUPDSRV
		--------------------------------------
		TO_DATE(stg.CLI_DATCADALT,'YYYYMMDDHH24MISS'),
		--------------------------------------
		-- 8 SRKPCH
		--------------------------------------
		NULL,
		--------------------------------------
		-- 9 BALGRPSRV
		--------------------------------------
		NULL,
		--------------------------------------
		-- 10 INSDTE
		--------------------------------------
		SYSDATE, 
		--------------------------------------
		-- 11 UPDDTE
		--------------------------------------
		NULL,
		--------------------------------------
		-- 12 PKGID
		--------------------------------------
		NULL, 
		--------------------------------------
		-- 13 CODSRVTYPBRM
		--------------------------------------
		'/service', 
		--------------------------------------
		-- 14 SRKACT
		--------------------------------------
		act.SRKACT,
		--------------------------------------
		-- 15 SACCMPCODECRM
		--------------------------------------
		NULL,
		--------------------------------------
		-- 16 SACCMPCODEBLL
		--------------------------------------
		NULL,
		--------------------------------------
		-- 17 CMPCODECRM
		--------------------------------------
		NULL,
		--------------------------------------
		-- 18 CMPCODEBLL
		--------------------------------------
		NULL,
		--------------------------------------
		-- 19 CODSRVTYPCRM
		--------------------------------------
		NULL,
		--------------------------------------
		-- 20 CODHOSTCRM
		--------------------------------------
		1,
		--------------------------------------
		-- 21 CODHOSTBLL
		--------------------------------------
		NULL,
		--------------------------------------
		-- 22 CODSRVTYPBLL
		--------------------------------------
	 	NULL
	FROM
	-- Tabela stg
	APP_STGOWN.I_CRM_CLIENTE stg
	-- Tabela bll
	INNER JOIN APP_RELOWN.ACCOUNT act
	ON act.CODACTCRM = stg.CLI_COD AND act.CODHOSTCRM = 1;			
	
MERGE INTO  APP_RELOWN.SERVICE ser
USING (     SELECT  ser1.CODSRV,
                    vcu_clicod,
					          vcu_ddd || vcu_telephone vcu_terminal
            from    APP_RELOWN.SERVICE ser1,
                    APP_STGOWN.i_crm_veloxcustomer vcu
            where 'IG-LP' || vcu.vcu_clicod = ser1.CODSRV
            and ser1.LGNSRV is null
            and ser1.CODHOSTCRM = 1
            and ser1.CODSRV like 'IG-LP%'
      )vcu
ON (  vcu.CODSRV = ser.CODSRV)
WHEN MATCHED THEN
UPDATE SET ser.LGNSRV = vcu.vcu_terminal;
	

	
-- Dar Grant
GRANT ALL ON SERVICE_LOGIN_AUX_I TO APP_RELOWN ;
	
-- 2 - CRIAR TABELA AUXILIAR DO SERVICO DE LOGIN PRINCIPAL BRT
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE APP_STGOWN.SERVICE_LOGIN_AUX_B';
EXCEPTION
	WHEN OTHERS THEN
	IF SQLCODE != -942 THEN
		RAISE;
	END IF;
END;


CREATE TABLE APP_STGOWN.SERVICE_LOGIN_AUX_B  nologging compress
AS  
  SELECT   *  FROM APP_RELOWN.SERVICE  WHERE 1<>1 
  UNION
  SELECT /*+ PARALLEL(STG,16) PARALLEL(ACT,16) */
		--------------------------------------
		-- 1 SRKSRV
		--------------------------------------
		app_stgown.F_SEQUENCE_SERVICE,
		--------------------------------------
		-- 2 CODSRV
		--------------------------------------
		'BRT-LP' || stg.CLI_COD,
		--------------------------------------
		-- 3 GLOSRV
		--------------------------------------
	  	'true',
		--------------------------------------
		-- 4 LGNSRV
		--------------------------------------
		stg.CLI_LOGIN,
		--------------------------------------
		-- 5 PSWSRV
		--------------------------------------
		STG.CLI_SENHA,
		--------------------------------------
		-- 6 DTECRESRV
		--------------------------------------
		TO_DATE(stg.CLI_DATACAD,'YYYYMMDDHH24MISS'),
		--------------------------------------
		-- 7 DTEUPDSRV
		--------------------------------------
		TO_DATE(stg.CLI_DATCADALT,'YYYYMMDDHH24MISS'),
		--------------------------------------
		-- 8 SRKPCH
		--------------------------------------
		NULL,
		--------------------------------------
		-- 9 BALGRPSRV
		--------------------------------------
		NULL,
		--------------------------------------
		-- 10 INSDTE
		--------------------------------------
		SYSDATE, 
		--------------------------------------
		-- 11 UPDDTE
		--------------------------------------
		NULL,
		--------------------------------------
		-- 12 PKGID
		--------------------------------------
		NULL, 
		--------------------------------------
		-- 13 CODSRVTYPBRM
		--------------------------------------
		'/service', 
		--------------------------------------
		-- 14 SRKACT
		--------------------------------------
		act.SRKACT,
		--------------------------------------
		-- 15 SACCMPCODECRM
		--------------------------------------
		NULL,
		--------------------------------------
		-- 16 SACCMPCODEBLL
		--------------------------------------
		NULL,
		--------------------------------------
		-- 17 CMPCODECRM
		--------------------------------------
		NULL,
		--------------------------------------
		-- 18 CMPCODEBLL
		--------------------------------------
		NULL,
		--------------------------------------
		-- 19 CODSRVTYPCRM
		--------------------------------------
		NULL,
		--------------------------------------
		-- 20 CODHOSTCRM
		--------------------------------------
		3,
		--------------------------------------
		-- 21 CODHOSTBLL
		--------------------------------------
		NULL,
		--------------------------------------
		-- 22 CODSRVTYPBLL
		--------------------------------------
	 	NULL
	FROM
	-- Tabela stg
	APP_STGOWN.B_CRM_CLIENTE stg
	-- Tabela bll
	INNER  JOIN APP_RELOWN.ACCOUNT act
	ON act.CODACTCRM = stg.CLI_COD AND act.CODHOSTCRM = 3 AND STG.CLI_HDKORGCOD <> 12;	
			
-- Dar Grant
GRANT ALL ON SERVICE_LOGIN_AUX_B TO APP_RELOWN ;


-- 3 - CRIAR TABELA AUXILIAR DO SERVICO DE LOGIN PRINCIPAL OI
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE APP_STGOWN.SERVICE_LOGIN_AUX_O';
EXCEPTION
	WHEN OTHERS THEN
	IF SQLCODE != -942 THEN
		RAISE;
	END IF;
END;
/

CREATE TABLE APP_STGOWN.SERVICE_LOGIN_AUX_O  nologging compress
AS  
  SELECT  *  FROM APP_RELOWN.SERVICE  WHERE 1<>1 
  UNION
  SELECT /*+ PARALLEL(STG,16) PARALLEL(ACT,16) */
		--------------------------------------
		-- 1 SRKSRV
		--------------------------------------
		app_stgown.F_SEQUENCE_SERVICE,
		--------------------------------------
		-- 2 CODSRV
		--------------------------------------
		'OI-LP' || stg.CLI_COD,
		--------------------------------------
		-- 3 GLOSRV
		--------------------------------------
	  	'true',
		--------------------------------------
		-- 4 LGNSRV
		--------------------------------------
		stg.CLI_LOGIN,
		--------------------------------------
		-- 5 PSWSRV
		--------------------------------------
		STG.CLI_SENHA,
		--------------------------------------
		-- 6 DTECRESRV
		--------------------------------------
		TO_DATE(stg.CLI_DATACAD,'YYYYMMDDHH24MISS'),
		--------------------------------------
		-- 7 DTEUPDSRV
		--------------------------------------
		TO_DATE(stg.CLI_DATCADALT,'YYYYMMDDHH24MISS'),
		--------------------------------------
		-- 8 SRKPCH
		--------------------------------------
		NULL,
		--------------------------------------
		-- 9 BALGRPSRV
		--------------------------------------
		NULL,
		--------------------------------------
		-- 10 INSDTE
		--------------------------------------
		SYSDATE, 
		--------------------------------------
		-- 11 UPDDTE
		--------------------------------------
		NULL,
		--------------------------------------
		-- 12 PKGID
		--------------------------------------
		NULL, 
		--------------------------------------
		-- 13 CODSRVTYPBRM
		--------------------------------------
		'/service', 
		--------------------------------------
		-- 14 SRKACT
		--------------------------------------
		act.SRKACT,
		--------------------------------------
		-- 15 SACCMPCODECRM
		--------------------------------------
		NULL,
		--------------------------------------
		-- 16 SACCMPCODEBLL
		--------------------------------------
		NULL,
		--------------------------------------
		-- 17 CMPCODECRM
		--------------------------------------
		NULL,
		--------------------------------------
		-- 18 CMPCODEBLL
		--------------------------------------
		NULL,
		--------------------------------------
		-- 19 CODSRVTYPCRM
		--------------------------------------
		NULL,
		--------------------------------------
		-- 20 CODHOSTCRM
		--------------------------------------
		2,
		--------------------------------------
		-- 21 CODHOSTBLL
		--------------------------------------
		NULL,
		--------------------------------------
		-- 22 CODSRVTYPBLL
		--------------------------------------
	 	NULL
	FROM
	-- Tabela stg
	APP_STGOWN.O_CRM_CLIENTE stg
	-- Tabela bll
	INNER  JOIN APP_RELOWN.ACCOUNT act
	ON act.CODACTCRM = stg.CLI_COD AND act.CODHOSTCRM = 2;	

-- Dar Grant
GRANT ALL ON APP_STGOWN.SERVICE_LOGIN_AUX_O TO APP_RELOWN ;

-- 4 - PASSO Criar tabela da entidade baseada nas tabelas auxiliares
INSERT /*+ APPEND */ INTO APP_RELOWN.SERVICE SELECT /*+ PARALLEL(SERVICE_LOGIN_AUX_I,16) */ * FROM APP_STGOWN.SERVICE_LOGIN_AUX_I;

COMMIT;

INSERT /*+ APPEND */ INTO APP_RELOWN.SERVICE SELECT /*+ PARALLEL(SERVICE_LOGIN_AUX_B,16) */ * FROM APP_STGOWN.SERVICE_LOGIN_AUX_B;

COMMIT;

INSERT /*+ APPEND */ INTO APP_RELOWN.SERVICE SELECT /*+ PARALLEL(SERVICE_LOGIN_AUX_O,16) */ * FROM APP_STGOWN.SERVICE_LOGIN_AUX_O;

COMMIT;
 
-- 5 - Contagens
SELECT COUNT(*) FROM APP_STGOWN.SERVICE_LOGIN_AUX_I;

SELECT COUNT(*) FROM APP_STGOWN.SERVICE_LOGIN_AUX_O;

SELECT COUNT(*) FROM APP_STGOWN.SERVICE_LOGIN_AUX_B;

-- 6 - DROPAR TABELAS AUXILIARES
DROP TABLE APP_STGOWN.SERVICE_LOGIN_AUX_I;
DROP TABLE APP_STGOWN.SERVICE_LOGIN_AUX_O;
DROP TABLE APP_STGOWN.SERVICE_LOGIN_AUX_B;

SPOOL OFF;
EXIT;
/

-- SELECT /*+ PARALLEL(SERVICE,32) */ COUNT(*) FROM  app_relown.SERVICE WHERE CODSRV LIKE '%LP%'