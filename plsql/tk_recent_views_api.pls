create or replace
package tk_recent_views_api as


g_entity_pk  number;
g_user       tk_recent_views.view_user%TYPE;

--------------------------------------------------------------------------------
--*
--* Get the number of entries to keep per user
--*
--------------------------------------------------------------------------------
function user_recent_views(
  p_user in varchar2
)
return number;


--------------------------------------------------------------------------------
--*
--*  Pages that are "edit"/view monitored
--*
--------------------------------------------------------------------------------
function page_in_current_view (
  p_page_id in number
)
return boolean;


--------------------------------------------------------------------------------
--*
--* Add or touch up the time stamp of a viewed entry
--* and add it to the users recent viewed list
--*
--* Additionally keep track of entities a user is viewing.
--*
--------------------------------------------------------------------------------
procedure touch(
    p_page_id     in  number
  , p_entity_id   in  number   default null
  , p_user        in  varchar2 default sys_context('APEX$SESSION','APP_USER')
);

end tk_recent_views_api;
/
