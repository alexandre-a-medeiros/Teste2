----------------------------------------------------------------------------
-- ATENCAO AOS COMENTARIOS "MUDAR"

connect APP_STGOWN/APP_STGOWNx#y@MIGDW

spool Account.ini.BRT.1.LOG

SET SERVEROUTPUT ON;
SET TIME ON;
SET TIMING ON;

ALTER SESSION ENABLE PARALLEL DML;
ALTER SESSION ENABLE PARALLEL QUERY;

-- 1 - PASSO INICIAL CRIAR TABELA AUXILIAR COM ACCOUNT BRT
BEGIN
   EXECUTE IMMEDIATE 'drop table APP_STGOWN.ACCOUNT_AUX_B';
EXCEPTION
	WHEN OTHERS THEN
	IF SQLCODE != -942 THEN
		RAISE;
	END IF;
END;
/

CREATE TABLE APP_STGOWN.ACCOUNT_AUX_B  nologging compress
AS  
  SELECT *  FROM APP_RELOWN.ACCOUNT  WHERE 1<>1 
  UNION
	SELECT /*+ PARALLEL(stg,16) */
		--------------------------------------
		-- 2 SRKACT
		--------------------------------------
		app_stgown.F_SEQUENCE_ACCOUNT,
		--------------------------------------
		-- 3 INSDTE
		--------------------------------------
		SYSDATE,
		--------------------------------------
		-- 4 UPDDTE
		--------------------------------------
		NULL,
		--------------------------------------
		-- 5 CODACTCRM
		--------------------------------------
		stg.CLI_COD,
		--------------------------------------
		-- 6 BUSTYP
		--------------------------------------
		CASE 
					WHEN stg.CLI_TIPOPESSOA=1 THEN 'C'
					WHEN stg.CLI_TIPOPESSOA=2 THEN 'B'
					ELSE NULL
		END,
		--------------------------------------
		-- 7 DTEUPDACT
		--------------------------------------
		TO_DATE(stg.CLI_DATCADALT,'YYYYMMDDHH24MISS'),
		--------------------------------------
		-- 8 DTECREACT
		--------------------------------------
		TO_DATE(stg.CLI_DATACAD,'YYYYMMDDHH24MISS'),
		--------------------------------------
		-- 9 EMAACT
		--------------------------------------
		stg.CLI_LOGIN,
		--------------------------------------
		-- 10 FIRSTNAM
		--------------------------------------
		CASE
			WHEN stg.CLI_TIPOPESSOA =  2 THEN TRIM(SUBSTR(stg.CLI_CONTATO,1,INSTR(stg.CLI_CONTATO,' '))) 
			ELSE TRIM(SUBSTR(stg.CLI_NOME,1,INSTR(stg.CLI_NOME,' ')))  
		END, 
		--------------------------------------
		-- 11 MIDNAM
		--------------------------------------
		NULL,
		--------------------------------------
		-- 12 LASTNAM
		--------------------------------------
		CASE
			WHEN stg.CLI_TIPOPESSOA =  2 THEN TRIM(SUBSTR(stg.CLI_CONTATO,INSTR(stg.CLI_CONTATO,' '))) 
			ELSE TRIM(SUBSTR(stg.CLI_NOME,INSTR(stg.CLI_NOME,' ')))  
		END, 
		--------------------------------------
		-- 13 SAL
		--------------------------------------
		' ', 
		--------------------------------------
		-- 14 COMPNAM
		--------------------------------------
		CASE 
			WHEN stg.CLI_TIPOPESSOA =  2 THEN stg.CLI_NOME
			ELSE NULL     
		END,
		--------------------------------------
		-- 15 CPFCNPJ
		--------------------------------------
		stg.CLI_CPF,
		--------------------------------------
		-- 16 MUNAPP
		--------------------------------------
		Null,
		--------------------------------------
		-- 17 STTAPP
		--------------------------------------
		stg.CLI_CONTAB_INSC_ESTADUAL,
		--------------------------------------
		-- 18 SEGACT
		--------------------------------------
		Null,
		--------------------------------------
		-- 19 EMAALT
		--------------------------------------
		CASE WHEN INSTR(NVL(STG.CLI_EMAIL,''),'@') < 1 THEN
		LOWER(STG.CLI_EMAIL||'@brturbo.com.br')
		ELSE
		LOWER(STG.CLI_EMAIL) end 
		AS CLI_EMAIL,
		--------------------------------------
		-- 20 CODACTSTEBRM
		--------------------------------------
		'A',
		--------------------------------------
		-- 21 CODACTBRM
		--------------------------------------
		'BRT-' || stg.CLI_COD,
		--------------------------------------
		-- 22 CODACTBLL
		--------------------------------------
		stg.CLI_COD,
		--------------------------------------
		-- 23 CODHOSTCRM
		--------------------------------------
		3,
		--------------------------------------
		-- 24 CODHOSTBLL
		--------------------------------------
		3,
		--------------------------------------
		-- 25 FLGTST
		--------------------------------------
		CASE 
         	WHEN UPPER(stg.CLI_NOME) = 'FULANO DE TAL'
              OR UPPER(stg.CLI_EMAIL) LIKE 'TESTEPRODUTO%'
              OR UPPER(stg.CLI_NOME) LIKE 'TESTEPRODUTO%'
              OR UPPER(stg.Cli_Login) LIKE 'TESTEPRODUTO%' THEN 1
         	ELSE 0
   	 	END,
		--------------------------------------
		-- 26 BIRTHDAY_T
		--------------------------------------
		to_date(stg.CLI_DATNAS,'DD/MM/YYYY'),
		--------------------------------------
		-- 27 BROADBAND_FLAG
		--------------------------------------
		NULL,
		--------------------------------------
		-- 28 CHILDREN_COUNT
		--------------------------------------
		NULL,
		--------------------------------------
		-- 29 GENDER
		--------------------------------------
		DECODE(stg.CLI_SEXO,'F',1,'M',2,NULL),
		--------------------------------------
		-- 30 MARITAL_STATUS
		--------------------------------------
		stg.CLI_MRSCODE,
		--------------------------------------
		-- 31 PJ_NAME
		--------------------------------------
		CASE WHEN stg.CLI_TIPOPESSOA = 2
			THEN stg.CLI_CONTATO
			ELSE NULL 
		END ,
		--------------------------------------
		-- 32 PPZ_LOGIN
		--------------------------------------
		NULL,
		--------------------------------------
		-- 33 SCHOLARITY
		--------------------------------------
		stg.CLI_EDLCODE,
		--------------------------------------
		-- 34 SECRET_ANSWER
		--------------------------------------
		NULL,
		--------------------------------------
		-- 35 SECRET_QUESTION
		--------------------------------------		
		NULL  	 	   	 	
	FROM
	-- Tabela stg
	APP_STGOWN.B_CRM_CLIENTE stg
	where CLI_HDKORGCOD not in (12);
	
-- Dar Grant		 
GRANT ALL ON ACCOUNT_AUX_B TO APP_RELOWN;
	
-- 2 - Contagens

-- BRT CRM
SELECT COUNT(*) FROM ACCOUNT_AUX_B;


SPOOL OFF;
EXIT;
/