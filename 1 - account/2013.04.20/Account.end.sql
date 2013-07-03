----------------------------------------------------------------------------
-- ATENCAO AOS COMENTARIOS "MUDAR"

connect APP_RELOWN/APP_RELOWNx#z@MIGDW

spool Account.end.1.LOG

SET SERVEROUTPUT ON;
SET TIME ON;
SET TIMING ON;

ALTER SESSION ENABLE PARALLEL DML;
ALTER SESSION ENABLE PARALLEL QUERY;

-- 1 - PASSO INICIAL dropar tabela da entidade
--BEGIN
--   EXECUTE IMMEDIATE 'TRUNCATE TABLE APP_RELOWN.ACCOUNT';
--EXCEPTION
--	WHEN OTHERS THEN
--	IF SQLCODE != -942 THEN
--		RAISE;
--	END IF;
--END;
--
--BEGIN
--   EXECUTE IMMEDIATE 'DROP SEQUENCE APP_RELOWN.SEQ_SRK_ACCOUNT';
--EXCEPTION
--	WHEN OTHERS THEN
--	IF SQLCODE != -942 THEN
--		RAISE;
--	END IF;
--END;

/*
CREATE TABLE "APP_RELOWN"."ACCOUNT" 
   (	"SRKACT" NUMBER, 
	"INSDTE" TIMESTAMP (3), 
	"UPDDTE" TIMESTAMP (3), 
	"CODACTCRM" NUMBER, 
	"BUSTYP" CHAR(1), 
	"DTEUPDACT" TIMESTAMP (3), 
	"DTECREACT" TIMESTAMP (3), 
	"EMAACT" VARCHAR2(255), 
	"FIRSTNAM" VARCHAR2(255), 
	"MIDNAM" VARCHAR2(255), 
	"LASTNAM" VARCHAR2(255), 
	"SAL" VARCHAR2(10), 
	"COMPNAM" VARCHAR2(255), 
	"CPFCNPJ" VARCHAR2(50), 
	"MUNAPP" VARCHAR2(255), 
	"STTAPP" VARCHAR2(255), 
	"SEGACT" VARCHAR2(10), 
	"EMAALT" VARCHAR2(255), 
	"CODACTSTEBRM" VARCHAR2(1), 
	"CODACTBRM" VARCHAR2(50), 
	"CODACTBLL" NUMBER, 
	"CODHOSTCRM" NUMBER, 
	"CODHOSTBLL" NUMBER, 
	"FLGTST" NUMBER, 
	"BIRTHDAY_T" DATE, 
	"BROADBAND_FLAG" NUMBER, 
	"CHILDREN_COUNT" NUMBER, 
	"GENDER" NUMBER, 
	"MARITAL_STATUS" NUMBER, 
	"PJ_NAME" VARCHAR2(255), 
	"PPZ_LOGIN" VARCHAR2(255), 
	"SCHOLARITY" NUMBER, 
	"SECRET_ANSWER" VARCHAR2(255), 
	"SECRET_QUESTION" VARCHAR2(255)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 0 PCTUSED 40 INITRANS 1 MAXTRANS 255 
  COMPRESS BASIC LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TSD_MIGDW" ;
  
  CREATE UNIQUE INDEX "APP_RELOWN"."PK_ACCOUNT" ON "APP_RELOWN"."ACCOUNT" ("SRKACT") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOLOGGING 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TSI_MIGDW" ;
  
  CREATE INDEX "APP_RELOWN"."I_ACCOUNT_2" ON "APP_RELOWN"."ACCOUNT" ("CODACTBLL", "CODHOSTBLL") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOLOGGING 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TSI_MIGDW" ;
  
  CREATE INDEX "APP_RELOWN"."I_ACCOUNT_1" ON "APP_RELOWN"."ACCOUNT" ("CODACTCRM", "CODHOSTCRM") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOLOGGING 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TSI_MIGDW" ;
  
  ALTER TABLE "APP_RELOWN"."ACCOUNT" ADD CONSTRAINT "PK_ACCOUNT" PRIMARY KEY ("SRKACT")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOLOGGING 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TSI_MIGDW"  ENABLE;
   COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."INSDTE" IS 'Data de cria��o do registro na tabela';
   COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."UPDDTE" IS 'Data de atualiza��o do registro na tabela';
   COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."CODACTCRM" IS 'Legacy ID do CRM';
   COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."BUSTYP" IS 'B-Business,C-Consumer';
   COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."DTEUPDACT" IS 'Effective time of modification of this account on an external system.';
   COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."DTECREACT" IS 'Created date and time of this account on an external system.';
   COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."EMAACT" IS 'Email address for the contact';
   COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."FIRSTNAM" IS 'First name of the contact';
   COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."MIDNAM" IS 'Middle name of the contact';
   COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."LASTNAM" IS 'Last name of the contact';
   COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."SAL" IS 'Salutation for the contact name';
   COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."COMPNAM" IS 'Companhia (apenas para empresarial)';
   COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."EMAALT" IS 'E-mail Alternativo - Legado';
   COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."CODACTBRM" IS 'Codigo do Legado enviado para o BRM';
   COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."CODACTBLL" IS 'Legacy ID do BILLING quando existir';
   COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."FLGTST" IS 'Indicador que o registro e de teste';
  GRANT ALL ON "APP_RELOWN"."ACCOUNT" TO "APP_STGOWN";
  CREATE SEQUENCE  "APP_RELOWN"."SEQ_SRK_ACCOUNT"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE NOORDER  NOCYCLE ;
  GRANT ALTER ON "APP_RELOWN"."SEQ_SRK_ACCOUNT" TO "APP_STGOWN";
  GRANT SELECT ON "APP_RELOWN"."SEQ_SRK_ACCOUNT" TO "APP_STGOWN";  
*/



-- 2 - PASSO Criar tabela da entidade baseada nas tabelas auxiliares
--CREATE TABLE "APP_RELOWN"."ACCOUNT" 
--AS
INSERT INTO APP_RELOWN.ACCOUNT
SELECT /*+ PARALLEL(ACCOUNT_AUX_O,16) */ * FROM APP_STGOWN.ACCOUNT_AUX_O
UNION ALL
SELECT  /*+ PARALLEL(ACCOUNT_AUX_BO,16) */ * FROM APP_STGOWN.ACCOUNT_AUX_BO
UNION ALL
SELECT  /*+ PARALLEL(ACCOUNT_AUX_I,16) */* FROM APP_STGOWN.ACCOUNT_AUX_I
UNION ALL
SELECT  /*+ PARALLEL(ACCOUNT_AUX_BI,16) */* FROM APP_STGOWN.ACCOUNT_AUX_BI
UNION ALL
SELECT  /*+ PARALLEL(ACCOUNT_AUX_B,16) */ * FROM APP_STGOWN.ACCOUNT_AUX_B;

COMMIT;
-- Dar Grant
GRANT ALL ON APP_RELOWN.ACCOUNT TO APP_STGOWN;

-- Criar comentarios
COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."INSDTE" IS 'Data de cria��o do registro na tabela';
COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."UPDDTE" IS 'Data de atualiza��o do registro na tabela';
COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."CODACTCRM" IS 'Legacy ID do CRM';
COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."BUSTYP" IS 'B-Business,C-Consumer';
COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."DTEUPDACT" IS 'Effective time of modification of this account on an external system.';
COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."DTECREACT" IS 'Created date and time of this account on an external system.';
COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."EMAACT" IS 'Email address for the contact';
COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."FIRSTNAM" IS 'First name of the contact';
COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."MIDNAM" IS 'Middle name of the contact';
COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."LASTNAM" IS 'Last name of the contact';
COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."SAL" IS 'Salutation for the contact name';
COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."COMPNAM" IS 'Companhia (apenas para empresarial)';
COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."EMAALT" IS 'E-mail Alternativo - Legado';
COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."CODACTBRM" IS 'Codigo do Legado enviado para o BRM';
COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."CODACTBLL" IS 'Legacy ID do BILLING quando existir';
COMMENT ON COLUMN "APP_RELOWN"."ACCOUNT"."FLGTST" IS 'Indicador que o registro e de teste';

create index APP_RELOWN.I_ACCOUNT_1 on APP_RELOWN.ACCOUNT (CODACTCRM,CODHOSTCRM);
create index APP_RELOWN.I_ACCOUNT_2 on APP_RELOWN.ACCOUNT (CODACTBLL,CODHOSTBLL);

-- dropar tabelas auxiliares
drop table APP_STGOWN.ACCOUNT_AUX_O;
drop table APP_STGOWN.ACCOUNT_AUX_BO;
drop table APP_STGOWN.ACCOUNT_AUX_I;
drop table APP_STGOWN.ACCOUNT_AUX_BI;
drop table APP_STGOWN.ACCOUNT_AUX_B;	


-- 3 - Inserir na Entity Impact
INSERT INTO APP_RELOWN.ENTITY_IMPACT (ID_ENTIPT,INSDTE,STEXML,SRKENT,NAMENT,UPDDTE,CODEXECOBJMESH,SRKACT,SRKNODXML      ) 
SELECT 
	SEQ_ID_ENTIPT.NEXTVAL
	,SYSDATE
	,0
	,TMP.SRKACT
	,'ACCOUNT'
	,Null
	,1 -- Execution
	,TMP.SRKACT
	,XNO.SRKNODXML
FROM 	APP_RELOWN.ACCOUNT TMP,
   		APP_RELOWN.NODE_XML XNO 
WHERE XMLRUL = 'ACCOUNT' ;

	
-- 4 - Contagens

-- Oi
SELECT COUNT(*) Oi_CRM_STG
FROM app_stgown.o_crm_cliente CRM;

SELECT COUNT(*) Oi_BLL_STG
FROM app_stgown.bo_crm_cliente bll;

SELECT COUNT(*) Oi_CRM_BLL_STG
FROM app_stgown.bo_crm_cliente bll,
     app_stgown.o_crm_cliente crm
WHERE bll.cli_igcode = crm.cli_cod;


-- Ig
SELECT COUNT(*) Ig_CRM_STG
FROM app_stgown.i_crm_cliente CRM;

SELECT COUNT(*) Ig_BLL_STG_ALL
FROM app_stgown.bi_crm_cliente bll;

SELECT COUNT(*) Ig_BLL_STG_ETP_IG
FROM app_stgown.bi_crm_cliente bll
WHERE BLL.CLI_ETPCODE IN (3,4);

SELECT COUNT(*) Ig_CRM_BLL_STG
FROM app_stgown.bi_crm_cliente bll,
     app_stgown.i_crm_cliente crm
WHERE bll.cli_igcode = crm.cli_cod;

SELECT COUNT(*) Ig_CRM_BLL_STG_ETP_IG
FROM app_stgown.bi_crm_cliente bll,
     app_stgown.i_crm_cliente crm
WHERE bll.cli_igcode = crm.cli_cod
AND BLL.CLI_ETPCODE IN (3,4);

-- BRT
SELECT COUNT(*) Brt_CRM
from APP_STGOWN.B_CRM_CLIENTE stg
where CLI_HDKORGCOD not in (12);


-- Relacional
select act.codhostcrm,act.codhostbll,count(*)
from account act
group by act.codhostcrm,act.codhostbll;


SPOOL OFF;
EXIT;
/