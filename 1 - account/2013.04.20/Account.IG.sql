----------------------------------------------------------------------------
-- ATENCAO AOS COMENTARIOS "MUDAR"

connect APP_STGOWN/APP_STGOWNx#y@MIGDW

spool Account.ini.IG.1.LOG

SET SERVEROUTPUT ON;
SET TIME ON;
SET TIMING ON;

ALTER SESSION ENABLE PARALLEL DML;
ALTER SESSION ENABLE PARALLEL QUERY;

-- 1 - PASSO INICIAL CRIAR TABELA AUXILIAR COM ACCOUNT IG CRM
BEGIN
   EXECUTE IMMEDIATE 'drop table APP_STGOWN.ACCOUNT_AUX_I';
EXCEPTION
	WHEN OTHERS THEN
	IF SQLCODE != -942 THEN
		RAISE;
	END IF;
END;
/

CREATE TABLE APP_STGOWN.ACCOUNT_AUX_I  nologging compress
AS  
  SELECT *  FROM APP_RELOWN.ACCOUNT  WHERE 1<>1 
  UNION
	SELECT /*+ PARALLEL(stg,32) PARALLEL(bll,32)*/
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
		Null,
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
		bll.cli_contab_insc_municipal,
		--------------------------------------
		-- 17 STTAPP
		--------------------------------------
		bll.cli_contab_insc_estadual,
		--------------------------------------
		-- 18 SEGACT
		--------------------------------------
		Null,
		--------------------------------------
		-- 19 EMAALT
		--------------------------------------
		stg.CLI_EMAIL,
		--------------------------------------
		-- 20 CODACTSTEBRM
		--------------------------------------
		'A',
		--------------------------------------
		-- 21 CODACTBRM
		--------------------------------------
		'IG-' || stg.CLI_COD,
		--------------------------------------
		-- 22 CODACTBLL
		--------------------------------------
	 	bll.cli_cod,
		--------------------------------------
		-- 23 CODHOSTCRM
		--------------------------------------
		1,
		--------------------------------------
		-- 24 CODHOSTBLL
		--------------------------------------
		CASE 
         WHEN BLL.CLI_COD IS NOT NULL THEN 6
         ELSE NULL
    	END,
		--------------------------------------
		-- 25 FLGTST
		--------------------------------------
		CASE 
         	WHEN UPPER(stg.CLI_NOME) = 'FULANO DE TAL'
              OR UPPER(stg.CLI_EMAIL) LIKE 'TESTEPRODUTO%'
              OR UPPER(stg.CLI_NOME) LIKE 'TESTEPRODUTO%'
              OR UPPER(stg.Cli_Login) LIKE 'TESTEPRODUTO%' THEN 1
         	ELSE 0
   	 	END ,
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
		Y.ppz_login,
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
	APP_STGOWN.I_CRM_CLIENTE stg
	-- Tabela bll
	LEFT JOIN APP_STGOWN.BI_CRM_CLIENTE bll
	ON bll.cli_igcode = stg.CLI_COD
	-- PPZ
	LEFT JOIN   (     SELECT CLI_COD,CREATIONDATE,ppz_login
				            FROM (
          				          SELECT CLG.CLG_CLICOD CLI_COD,
          				                 CLG.CLG_CREATIONDATE CREATIONDATE,
          				                 CLG.CLG_LOGIN || '@' || CLG.CLG_DOMAIN ppz_login,
          				                 DENSE_RANK( ) OVER (PARTITION BY CLG.CLG_CLICOD ORDER BY CLG.CLG_CREATIONDATE DESC,CLG.ROWID DESC) AS NRANK
          				          FROM 	APP_STGOWN.i_crm_veloxcustomer 		  VCU,
          				          		  APP_STGOWN.I_CRM_CUSTOMERLOGIN	    CLG
          				          WHERE CLG.CLG_CLICOD = VCU.VCU_CLICOD
          				          AND 	INSTR(CLG.CLG_DOMAIN,'.',1) = 0
				                 ) X 
                   WHERE X.NRANK=1   
                ) Y   
	ON STG.CLI_COD = Y.CLI_COD;			
	
-- Criar Indice	
create index I_ACCOUNT_AUX_I_1 on ACCOUNT_AUX_I (CODACTBLL);

-- Dar Grant
GRANT ALL ON ACCOUNT_AUX_I TO APP_RELOWN ;
	
-- 2 - PASSO INICIAL CRIAR TABELA AUXILIAR COM ACCOUNT IG BILL QUE NAO EXISTEM NO CRM
BEGIN
   EXECUTE IMMEDIATE 'drop table APP_STGOWN.ACCOUNT_AUX_BI';
EXCEPTION
	WHEN OTHERS THEN
	IF SQLCODE != -942 THEN
		RAISE;
	END IF;
END;
/	
COMMIT;
CREATE TABLE APP_STGOWN.ACCOUNT_AUX_BI  nologging compress
AS
  SELECT *  FROM APP_RELOWN.ACCOUNT  WHERE 1<>1 
  UNION
	SELECT /*+ PARALLEL(bll,16) */
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
		Null,
		--------------------------------------
		-- 5 CODACTCRM
		--------------------------------------
		NULL,
		--------------------------------------
		-- 6 BUSTYP
		--------------------------------------
		NULL,
		--------------------------------------
		-- 7 DTEUPDACT
		--------------------------------------
		NULL,
		--------------------------------------
		-- 8 DTECREACT
		--------------------------------------
		NULL,
		--------------------------------------
		-- 9 EMAACT
		--------------------------------------
		NULL,
		--------------------------------------
		-- 10 FIRSTNAM
		--------------------------------------
		NULL, 
		--------------------------------------
		-- 11 MIDNAM
		--------------------------------------
		NULL,
		--------------------------------------
		-- 12 LASTNAM
		--------------------------------------
		NULL, 
		--------------------------------------
		-- 13 SAL
		--------------------------------------
		NULL, 
		--------------------------------------
		-- 14 COMPNAM
		--------------------------------------
		NULL,
		--------------------------------------
		-- 15 CPFCNPJ
		--------------------------------------
		NULL,
		--------------------------------------
		-- 16 MUNAPP
		--------------------------------------
		bll.cli_contab_insc_municipal,
		--------------------------------------
		-- 17 STTAPP
		--------------------------------------
		bll.cli_contab_insc_estadual,
		--------------------------------------
		-- 18 SEGACT
		--------------------------------------
		Null,
		--------------------------------------
		-- 19 EMAALT
		--------------------------------------
		Null,
		--------------------------------------
		-- 20 CODACTSTEBRM
		--------------------------------------
		Null,
		--------------------------------------
		-- 21 CODACTBRM
		--------------------------------------
		Null, 
 		--------------------------------------
		-- 22 CODACTBLL
		--------------------------------------
	    bll.cli_cod,
		--------------------------------------
		-- 23 CODHOSTCRM
		--------------------------------------
		Null,     
		--------------------------------------
		-- 24 CODHOSTBLL
		--------------------------------------
		6 CODHOSTBLL,
		--------------------------------------
		-- 25 FLGTST
		--------------------------------------
		CASE 
         WHEN UPPER(bll.CLI_NOME) = 'FULANO DE TAL'
              OR UPPER(bll.CLI_EMAIL) LIKE 'TESTEPRODUTO%'
              OR UPPER(bll.CLI_NOME) LIKE 'TESTEPRODUTO%'
              OR UPPER(bll.Cli_Login) LIKE 'TESTEPRODUTO%' THEN 1
         ELSE 0
    	END FLGTST,
		--------------------------------------
		-- 26 BIRTHDAY_T
		--------------------------------------
		NULL,
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
		NULL,
		--------------------------------------
		-- 30 MARITAL_STATUS
		--------------------------------------
		NULL,
		--------------------------------------
		-- 31 PJ_NAME
		--------------------------------------
		NULL,
		--------------------------------------
		-- 32 PPZ_LOGIN
		--------------------------------------
		NULL,
		--------------------------------------
		-- 33 SCHOLARITY
		--------------------------------------
		NULL,
		--------------------------------------
		-- 34 SECRET_ANSWER
		--------------------------------------
		NULL,
		--------------------------------------
		-- 35 SECRET_QUESTION
		--------------------------------------		
		NULL  	 	    	
	FROM
	-- Tabela bll
	APP_STGOWN.BI_CRM_CLIENTE bll
  WHERE
  BLL.CLI_ETPCODE IN (3,4)
  AND NOT EXISTS (   SELECT 1
                     FROM APP_STGOWN.ACCOUNT_AUX_I AUX
                     WHERE BLL.CLI_COD = AUX.CODACTBLL
                     AND AUX.CODHOSTBLL = 6
                 );
                 
-- Dar Grant                
GRANT ALL ON ACCOUNT_AUX_BI TO APP_RELOWN ;


-- 3 - Contagens

-- Por Enterprise
SELECT IVCL.PMT_ETPCODE,ETP2.ETP_NAME,ETP1.ETP_CODE,ETP1.ETP_NAME,COUNT(*)
FROM BI_CRM_CLIENTE    CLI,
     BI_ESP_ENTERPRISE ETP1,
     BI_ESP_ENTERPRISE ETP2,
     (    SELECT DISTINCT IVA.IVA_CLICOD,PMT.PMT_ETPCODE
          FROM   APP_STGOWN.BI_BLG_INVOICEACCOUNT iva,
                 APP_STGOWN.BI_BLG_PAYMENTDATA pmd,
                 APP_STGOWN.BI_BLG_PAYMENTMETHOD pmt
          WHERE pmd.pmd_pmtcode = pmt.pmt_code
          AND iva.iva_pmdcode = pmd.pmd_code
     ) IVCL
WHERE CLI.CLI_COD = IVCL.IVA_CLICOD
AND ETP1.ETP_CODE = CLI.CLI_ETPCODE
AND ETP2.ETP_CODE = IVCL.PMT_ETPCODE
GROUP BY IVCL.PMT_ETPCODE,ETP2.ETP_NAME,ETP1.ETP_CODE,ETP1.ETP_NAME;

-- IG CRM
SELECT COUNT(*) FROM ACCOUNT_AUX_I;

-- IG BILL que nao existe IG CRM
SELECT COUNT(*) FROM ACCOUNT_AUX_BI;


/*
MERGE INTO  APP_RELOWN.ACCOUNT act
USING (  SELECT CLI_COD,CREATIONDATE,ppz_login
				            FROM (
          				          SELECT CLG.CLG_CLICOD CLI_COD,
          				                 CLG.CLG_CREATIONDATE CREATIONDATE,
          				                 CLG.CLG_LOGIN || '@' || CLG.CLG_DOMAIN ppz_login,
          				                 DENSE_RANK( ) OVER (PARTITION BY CLG.CLG_CLICOD ORDER BY CLG.CLG_CREATIONDATE DESC,CLG.ROWID DESC) AS NRANK
          				          FROM 	APP_STGOWN.i_crm_veloxcustomer 		  VCU,
          				          		  APP_STGOWN.I_CRM_CUSTOMERLOGIN	    CLG
          				          WHERE CLG.CLG_CLICOD = VCU.VCU_CLICOD
          				          AND 	INSTR(CLG.CLG_DOMAIN,'.',1) = 0
				                 ) X 
                   WHERE X.NRANK=1   
	       ) tmp
ON (act.codactcrm = tmp.CLI_COD 
                  and act.codhostcrm = 1)
	WHEN MATCHED THEN
		UPDATE SET
		       act.ppz_login = tmp.ppz_login;
*/

SPOOL OFF;
EXIT;
/