
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
%let TBL=      'TABLE11';                     /* Table name, ALL CAPS, in single quotes */
/*********************/
/* End USER INPUTS   */
/*********************/

/* Using SYS.ALL_IND_COLUMNS to Determine Table Indexes. */

ODS HTML body="&unixpath.&ODBshrt.DB_&OWNlong._&TBL._Indexes.html";
Title "Indexes on Schema &OWNlong., Table &TBL. in Database: &ODBlong.";
PROC SQL;
CONNECT to oracle as &ODBshrt. (path="&ODBlong" &ODBcred. );
/* CREATE table &TBL.indexes as */
SELECT
*
FROM connection to &ODBshrt.
  (
   SELECT
   INDEX_NAME, COLUMN_POSITION, COLUMN_NAME
   FROM SYS.all_ind_columns
   WHERE TABLE_OWNER=&OWNlong. and TABLE_NAME=&TBL.
   ORDER by TABLE_OWNER, TABLE_NAME, INDEX_NAME, COLUMN_POSITION
  )
;
DISCONNECT from &odbshrt.;
QUIT;
Title;
ODS HTML close;
