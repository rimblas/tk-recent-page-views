
CLEAR SCREEN
PROMPT 
PROMPT   ________. .__     __. 
PROMPT  |        |  |  \  /  | 
PROMPT  .--.  .--.  |   ./  /  
PROMPT     |  |     |  . `\    
PROMPT     |  |     |  |\   \  
PROMPT     |__|     |__| \___` 
PROMPT  
PROMPT  ======================================================================
PROMPT  == tk-recent-page-views
PROMPT  == Software Version: 1.00
PROMPT  ============================= Installation ===========================
PROMPT

-- Terminate the script on Error during the beginning
whenever sqlerror exit

--  define - Sets the character used to prefix substitution variables
set define '^'
--  verify off prevents the old/new substitution message
set verify off
--  feedback - Displays the number of records returned by a script ON=1
set feedback off
--  timing - Displays the time that commands take to complete
set timing off


PROMPT _________________________________________________
PROMPT |   Installing all tables                       |
PROMPT _________________________________________________
PROMPT

@install/_ins.sql


PROMPT
PROMPT == Package Specs
PROMPT =================

PROMPT .. tk_recent_views_api
@@plsql/tk_recent_views_api.pls


PROMPT
PROMPT == Package Bodies
PROMPT ==================

PROMPT .. tk_recent_views_api
@@plsql/tk_recent_views_api.plb

PROMPT Done.



