﻿--  ###########################################################################
--  #                                                                         #
--  # Copyright (C) {2023}  Author: Wool Data, LLC (http://wooldata.com)      #
--  #                                                                         #
--  ###########################################################################

-- Set the date format for the current session to yyyy-mm-dd HH24:mi:ss
alter session set NLS_DATE_FORMAT = 'yyyy-mm-dd HH24:mi:ss';
-- Set the language for the current session to American
alter session set nls_language = 'AMERICAN';

-- Turn off display of output on the terminal
set termout off
-- Echo all SQL commands entered in the script to the output
set echo on
-- Set embedded SQL mode to be on
set emb on
-- Set number of lines per page to 0
set pages 0
-- Turn off display of the new page prompt
set newp none
-- Enable display of feedback for SQL commands
set feedb on
-- Trim trailing spaces in output
set trimsp on
-- Turn off use of tabs in output formatting
set tab off
-- Set column separator character to the pipe symbol "|"
set colsep |
-- Set the width for display of NUMBER columns to 32 characters
set numwidth 32
-- Set the maximum width of LONG raw columns to 65536 characters
set longc 65536
-- Set the maximum width of LONG columns to 1000000000 characters
set long 1000000000
-- Set line size to 32767 characters
set linesize 32767

-- Declare substitution variables to hold the values of the database name, date and file extension
column db_name new_value db_name_val
column date_val new_value date_val_val
column file_ext new_value file_ext_val

-- Query to retrieve the database name, the current date in the desired format, and the desired file extension
select name db_name, to_char(sysdate,'YYYYMMDD') date_val, '.dat' file_ext from V$DATABASE;

-- Use the substitution variables to dynamically build the file name for the output of the subsequent SQL statements
spool rman_cat_&db_name_val&date_val_val&file_ext_val

--Retrieve all columns of the "v$database" table
select * from v$database;
--Retrieve all columns of the "v$version" table
select v.* from v$version v;
--Retrieve all columns from "rc_rman_status" table where "end_time" is greater than the current date minus 31 days
select * from rc_rman_status where end_time > (SYSDATE - 31);
--Retrieve all columns from "rc_rman_configuration" table
select * from rc_rman_configuration;
--Retrieve all columns from "rc_database" table
select * from rc_database;
--Retrieve all columns from "rc_backup_piece" table where "completion_time" is greater than the current date minus 31 days
select * from rc_backup_piece where completion_time > (SYSDATE - 31);
--Retrieve all columns from "rc_backup_set" table where "completion_time" is greater than the current date minus 31 days
select * from rc_backup_set where completion_time > (SYSDATE - 31);
--Retrieve all columns from "rc_backup_datafile" table where "completion_time" is greater than the current date minus 31 days
select * from rc_backup_datafile where completion_time > (SYSDATE - 31);
--Retrieve all columns from "rc_datafile_copy" table where "completion_time" is greater than the current date minus 31 days
select * from rc_datafile_copy where completion_time > (SYSDATE - 31);
--Retrieve all columns from "rc_backup_files" table where "completion_time" is greater than the current date minus 31 days
select * from rc_backup_files where completion_time > (SYSDATE - 31);
--Stop spooling the output
spool off

--Exit the code
exit;