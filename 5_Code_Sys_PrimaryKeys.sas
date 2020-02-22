
/* SAS Global Forum 2011, Paper 133, Carole Jesse */
/* Program Name:  1_Code_SysAllViews3Fam.sas */

/*********************/
/* Begin USER INPUTS */
/*********************/
%let ODBcred=  user='cjesse' pw='bWFLA$01e';  /* credentials to the DB, Case Sensitive */
%let ODBlong=  database1.server1.com;         /* path to the DB */
%let ODBshrt=  db1sv1;                        /* alias for the DB */
%let unixpath= /userv1/grp1/cjesse/;          /* UNIX path for output, Case Sensitive */
*%let OWNlong=  'OWNER1';                      /* Schema name, ALL CAPS, in single quotes */
%let TBL=      'TABLE1';                      /* Table name, ALL CAPS, in single quotes */
/*********************/
/* End USER INPUTS   */
/*********************/

/* Using SYS.ALL_CONSTRAINTS and SYS.ALL_CONS_COLUMNS to Determine Table Primary Keys. */

/* ALL Primary Keys in the Database */
ODS HTML body="&unixpath.&ODBshrt.DB_PrimaryKeys.html";
Title "All Primary Keys in the ORACLE database: &ODBlong.";
PROC SQL;
CONNECT to oracle as &ODBshrt. (path="&ODBlong." &ODBcred. );
/*CREATE table allPriKeys as*/
SELECT
*
FROM connection to &ODBshrt.
  (
   SELECT 
   b.OWNER,
   a.TABLE_NAME, 
   a.COLUMN_NAME, 
   a.POSITION, 
   b.STATUS
   FROM SYS.all_constraints b, SYS.all_cons_columns a
   WHERE 
       b.CONSTRAINT_TYPE = 'P'
   AND b.CONSTRAINT_NAME = a.CONSTRAINT_NAME
   AND b.OWNER = a.OWNER
   ORDER BY b.OWNER, a.TABLE_NAME, a.POSITION
  )
;
DISCONNECT from &ODBshrt.;
QUIT;
Title;
ODS HTML close;

/* Alternate form of the pass-through SQL, to get a Primary Keys on specific table.
   Substitue this as the oracle pass through select above.
  (
   SELECT 
   b.OWNER,
   a.TABLE_NAME, 
   a.COLUMN_NAME, 
   a.POSITION, 
   b.STATUS
   FROM SYS.all_constraints b, SYS.all_cons_columns a
   WHERE 
       a.TABLE_NAME = &TBL.
   AND b.CONSTRAINT_TYPE = 'P'
   AND b.CONSTRAINT_NAME = a.CONSTRAINT_NAME
   AND b.OWNER = a.OWNER
   ORDER BY b.OWNER, a.TABLE_NAME, a.POSITION
  )
*/

/* Primary Keys in a specific Table in the DB */
ODS HTML body="&unixpath.&ODBshrt.DB_&TBL._PrimaryKeys.html";
Title "All Primary Keys in Table &TBL. in the ORACLE database: &ODBlong.";
PROC SQL;
CONNECT to oracle as &ODBshrt. (path="&ODBlong." &ODBcred. );
/* CREATE table TblPriKeys as */
SELECT
*
FROM connection to &ODBshrt.
  (
   SELECT 
   b.OWNER,
   a.TABLE_NAME, 
   a.COLUMN_NAME, 
   a.POSITION, 
   b.STATUS
   FROM SYS.all_constraints b, SYS.all_cons_columns a
   WHERE 
       a.TABLE_NAME = &TBL.
   AND b.CONSTRAINT_TYPE = 'P'
   AND b.CONSTRAINT_NAME = a.CONSTRAINT_NAME
   AND b.OWNER = a.OWNER
   ORDER BY b.OWNER, a.TABLE_NAME, a.POSITION
  )
;
DISCONNECT from &ODBshrt.;
quit;
Title;
ODS HTML close;