
/* SAS Global Forum 2011, Paper 133, Carole Jesse */
/* Program Name:  1_Code_SysAllViews3Fam.sas */

/*********************/
/* Begin USER INPUTS */
/*********************/
%let ODBcred=  user='cjesse' pw='bWFLA$01e';  /* credentials to the DB, Case Sensitive */
%let ODBlong=  database1.server2.com;         /* path to the DB */
%let ODBshrt=  db1sv2;                        /* alias for the DB */
%let unixpath= /userv1/grp1/cjesse/;          /* UNIX path for output, Case Sensitive */
*%let OWNlong=  'OWNER5';                      /* Schema name, ALL CAPS, in single quotes */
*%let TBL=      'TABLE236';                    /* Table name, ALL CAPS, in single quotes */
/*********************/
/* End USER INPUTS   */
/*********************/

/* Using SYS.USER_ROLE_PRIVS to Determine Granted Database Roles and Privileges. */

ODS HTML body="&unixpath.&ODBshrt.DB_RolesPrivs.html";
Title "Roles/Privs granted for &sysuserid. on Database: &ODBlong.";
PROC SQL;
CONNECT to oracle as &ODBshrt. (path="&ODBlong" &ODBcred. );
/* CREATE table myroles_&ODBshrt. as*/
SELECT
*
FROM connection to &ODBshrt.
  (
   SELECT
   USERNAME, GRANTED_ROLE
   FROM SYS.user_role_privs
  )
;
DISCONNECT from &ODBshrt.;
QUIT;
Title;
ODS HTML close;
