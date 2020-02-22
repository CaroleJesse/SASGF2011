
/* SAS Global Forum 2011, Paper 133, Carole Jesse */
/* Program Name:  1_Code_SysAllViews3Fam.sas */

/*********************/
/* Begin USER INPUTS */
/*********************/
%let ODBcred=  user='cjesse' pw='bWFLA$01e';  /* credentials to the DB, Case Sensitive */
%let ODBlong=  database1.server2.com;         /* path to the DB */
%let ODBshrt=  db1sv2;                        /* alias for the DB */
%let unixpath= /userv1/grp1/cjesse/;          /* UNIX path for output, Case Sensitive */
%let OWNlong=  'OWNER5';                      /* Schema name, ALL CAPS, in single quotes */
*%let TBL=      'TABLE236';                    /* Table name, ALL CAPS, in single quotes */
/*********************/
/* End USER INPUTS   */
/*********************/

/* Using SYS.ALL_TABLES to Determine Table Partitioning.                                   */

ODS HTML body="&unixpath.&ODBshrt.DB_&OWNlong._AllTables.html";
Title "Tables and Partitioning on Schema &OWNlong. in Database: &ODBlong.";
PROC SQL;
CONNECT to oracle as &ODBshrt. (path="&ODBlong." &ODBcred. );
/* CREATE table alltables as */
SELECT
TABLE_NAME, NUM_ROWS format=comma19.0, PARTITIONED
FROM connection to &ODBshrt.
  (
   SELECT TABLE_NAME, NUM_ROWS, PARTITIONED
   FROM SYS.all_tables
   WHERE OWNER=&OWNlong. and NUM_ROWS > 0
   ORDER by TABLE_NAME
  )
;
DISCONNECT from &ODBshrt.;
QUIT;
Title;
ODS HTML close;


/* Alternate form of the pass-through SQL, to get just the PARTITIONED tables:
  (
   SELECT TABLE_NAME, NUM_ROWS, PARTITIONED
   FROM SYS.all_tables
   WHERE OWNER=&OWNlong. and NUM_ROWS > 0 and PARTITIONED='YES'
   ORDER by NUM_ROWS DESC, TABLE_NAME
  )
*/

ODS HTML body="&unixpath.&ODBshrt.DB_&OWNlong._AllPartTables.html";
Title "Partitioned Tables on Schema &OWNlong. in Database: &ODBlong.";
PROC SQL;
CONNECT to oracle as &ODBshrt. (path="&ODBlong." &ODBcred. );
/* CREATE table allparttables as */
SELECT
TABLE_NAME, NUM_ROWS format=comma19.0, PARTITIONED
FROM connection to &ODBshrt.
  (
   SELECT
   TABLE_NAME, NUM_ROWS, PARTITIONED
   FROM SYS.all_tables
   WHERE OWNER=&OWNlong. and NUM_ROWS > 0 and PARTITIONED='YES'
   ORDER by NUM_ROWS DESC, TABLE_NAME
  )
;
DISCONNECT from &ODBshrt.;
QUIT;
Title;
ODS HTML close;
