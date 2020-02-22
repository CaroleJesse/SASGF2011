
/* SAS Global Forum 2011, Paper 133, Carole Jesse */
/* Program Name:  1_Code_SysAllViews3Fam.sas */

/*********************/
/* Begin USER INPUTS */
/*********************/
%let ODBcred=  user='cjesse' pw='bWFLA$01e';  /* credentials to the DB, Case Sensitive */
%let ODBlong=  database1.server2.com;         /* path to the DB */
%let ODBshrt=  db1sv2;                        /* alias for the DB */
%let unixpath= /userv1/grp1/cjesse/;          /* UNIX path for output, Case Sensitive */
*%let OWNlong=  'OWNER5';                     /* Schema name, ALL CAPS, in single quotes */
*%let TBL=      'TABLE236';                   /* Table name, ALL CAPS, in single quotes */
/*********************/
/* End USER INPUTS   */
/*********************/

/* PART 1: Getting a listing of all SYS Views in the ALL_, USER_, and DBA_ families*/
ODS HTML body="&unixpath.&ODBshrt.DB_SysAllViews3Fam.html";
Title1 "Breakdown of SYS.ALL_VIEWS in ALL_, USER_, DBA_";
Title2 "For ORACLE database &ODBlong.";
PROC SQL;
CONNECT to oracle as &ODBshrt. (path="&ODBlong" &ODBcred. );
/* CREATE table SYSallviews as */
SELECT
SCANQ(VIEW_NAME,1,"_") as FAMILY,
*
FROM connection to &ODBshrt.
  (
   SELECT
   VIEW_NAME
   FROM SYS.all_views
   WHERE OWNER='SYS'
  )
WHERE SCANQ(VIEW_NAME,1,"_") in ('ALL','USER','DBA')
ORDER FAMILY, VIEW_NAME
;
DISCONNECT FROM &ODBshrt.;
QUIT;
Title1;
Title2;
ODS HTML close;

*options mlogic symbolgen mprint;

/* PART 2: Macro for listing SYS View contents, from a list of view names */

*Customized the list of SYS Views of interest.  ALL CAPS for view names.;
DATA sysviewlist;
format view_name $varying50.;
input view_name $;
/* example list of view names */
cards;
USER_ROLE_PRIVS
ALL_CONS_COLUMNS
ALL_IND_EXPRESSIONS
;
RUN;

*Auto-generate macro variables used to loop the listing.;
DATA _null_;
 set sysviewlist end=eof; 
 call symputx("vname"||cats(put(_N_,3.)), view_name);
 if eof then call symputx("nviews",_N_);
RUN;

*MACRO Definition: list the first 15 of observations from a SYS View.;
%MACRO prtviews(recs,vname);
Title "First &recs rows of view SYS.&vname in &ODBlong.";
PROC SQL inobs=&recs.;
CONNECT to oracle as &ODBshrt. (path="&ODBlong." &ODBcred. );
SELECT
*
FROM connection to &ODBshrt.
  (
   SELECT
   *
   FROM SYS.&vname.
  )
;
DISCONNECT FROM &ODBshrt.;
QUIT;
Title;
%MEND prntviews;

*Run the loop, once for each view in the list.;
ODS HTML body="&unixpath.&ODBshrt.DB_&nviews.view_listing.html";
%MACRO loop_prntviews;
 %do i=1 %to &nviews;
  %prtviews(recs=15,vname=&&vname&i..); /* can alter number of records here */
 %end;
%MEND loop_prntviews;
%loop_prntviews;
ODS HTML close;
