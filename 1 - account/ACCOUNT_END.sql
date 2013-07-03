
SET SERVEROUTPUT ON;
SET TIME ON;
SET TIMING ON;

SPOOL ACCOUNT.END.LOG

ALTER SESSION ENABLE PARALLEL DML;

ALTER SESSION ENABLE PARALLEL QUERY;

EXEC DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SS')||'- INICIO');

GRANT ALL ON APP_RELOWN.ACCOUNT TO APP_STGOWN;

GRANT ALL ON APP_RELOWN.ACCOUNT TO APP_TDWOWN;

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

--criar indices
CREATE INDEX APP_RELOWN.ACC_CODACTCRMCODHOSTCRM ON APP_RELOWN.ACCOUNT(CODACTCRM, CODACTBLL, CODHOSTCRM) TABLESPACE TSI_MIGDW COMPRESS;
CREATE INDEX APP_RELOWN.ACC_CODACTBRMCODHOSTCRM ON APP_RELOWN.ACCOUNT(CODACTBRM) TABLESPACE TSI_MIGDW LOCAL;
CREATE INDEX APP_RELOWN.PK_ACCOUNT ON APP_RELOWN.ACCOUNT(SRKACT) TABLESPACE TSI_MIGDW ;
CREATE INDEX APP_RELOWN.IX_ACT_CODACTBLL_CODHOSTBLL ON APP_RELOWN.ACCOUNT(CODACTBLL, CODHOSTBLL) TABLESPACE TSI_MIGDW COMPRESS;
CREATE INDEX APP_RELOWN.I_ACCOUNT_01 ON APP_RELOWN.ACCOUNT(CODACTCRM) TABLESPACE TSI_MIGDW LOCAL;

ALTER TABLE APP_RELOWN.ACCOUNT ADD CONSTRAINT PK_ACCOUNT PRIMARY KEY (SRKACT) USING INDEX TABLESPACE TSI_MIGDW ;

EXEC DBMS_STATS.GATHER_TABLE_STATS('APP_RELOWN','ACCOUNT');

EXEC DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE,'DD-MM-YYYY HH24:MI:SS')||'- TERMINO');

SPOOL OFF;

EXIT;
/