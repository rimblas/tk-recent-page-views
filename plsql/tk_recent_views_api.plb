create or replace
package body tk_recent_views_api
as

-- duration of time someone is considered as viewing a record.
c_interval number := 1/24/60*3;  -- (3 minutes)

--------------------------------------------------------------------------------
--*
--*  Get the number of entries to keep per user
--*
--------------------------------------------------------------------------------
function user_recent_views (
  p_user in varchar2
)
return number
is
begin

  return nvl(apex_util.get_preference('TK_RECENT_PAGE_VIEWS', p_user), 10);

end user_recent_views;




--------------------------------------------------------------------------------
--*
--* Purge old entries in the recently viewed list
--* The recently viewed list is a sliding window with TK_RECENT_PAGE_VIEWS
--* entries
--*
--------------------------------------------------------------------------------
procedure remove_old_views (
  p_user in varchar2
)
is
  n  number;
begin

  n := user_recent_views(p_user);
  delete
    from tk_recent_views
   where id in
          (select id
             from (select id, dense_rank() over (order by viewed_on desc) dr
                     from tk_recent_views
                    where view_user = p_user
                  )
            where dr > n)
     and view_user = p_user;

end remove_old_views;






--------------------------------------------------------------------------------
--*
--*  Pages that are "edit"/view monitored
--*
--------------------------------------------------------------------------------
function page_in_current_view (
  p_page_id in number
)
return boolean
is
begin

/*
  <<<< CHANGE THE LIST OF PAGES IN THIS FUNCTION AS NEEDED
  Pages Monitored
  ----------------------------------------
  210 - Claims
  310 - Clients
  365 - Providers
  510 - Rules
  810 - Cases
*/
  return p_page_id in (210, 310, 365, 510, 810);

end page_in_current_view;





--------------------------------------------------------------------------------
--*
--* Purge old entries in the current viewed list older than c_interval
--*
--------------------------------------------------------------------------------
procedure remove_old_current_views (
  p_user in varchar2
)
is
  n  number;
begin

  -- remove all user page views older than c_interval
  delete from tk_current_views
   where view_user = p_user
     and (viewed_on + c_interval) < sysdate;

end remove_old_current_views;




--------------------------------------------------------------------------------
--*
--* Update the current_view time stamp of a viewed entry
--* every user can only be viewing one page at a time.
--*
--------------------------------------------------------------------------------
procedure current_view (
    p_page_id     in  number
  , p_entity_id   in  number   default null
  , p_user        in  varchar2 default sys_context('APEX$SESSION','APP_USER')
)
is
  l_now date;
begin
  l_now := sysdate;

  -- Globally set the current user
  g_user := p_user;

  if p_entity_id is not null and page_in_current_view(p_page_id) then
    -- Globally set the entity_id
    g_entity_pk := p_entity_id;

    -- touching page_id for p_user
    update tk_current_views
       set viewed_on = case
                        when view_user = p_user then
                          -- refresh the ownership for the same user
                          l_now
                        when view_user <> p_user and (viewed_on + c_interval) < l_now then
                          -- we have a new owner
                          l_now
                        else
                          -- keep the same viewed on
                          viewed_on
                        end
         , view_user = case
                        when view_user <> p_user and (viewed_on + c_interval) < l_now then
                          -- it's been long enough, change ownership
                          p_user
                        else
                          view_user
                        end
     where page_id   = p_page_id
       and entity_id = p_entity_id
     returning view_user into g_user;


    if SQL%ROWCOUNT = 0 then
      -- if the page_id and entity was not in the list we add it.
      insert into tk_current_views (
          page_id
        , entity_id
        , viewed_on
        , view_user
      ) values (
          p_page_id
        , p_entity_id
        , l_now
        , p_user
      );

      g_user := p_user;

    end if;
  else
    g_entity_pk := null;
  end if;

  -- Whenever something is added, see if we need to delete something
  remove_old_current_views(p_user);

end current_view;






--------------------------------------------------------------------------------
--*
--* Add or touch up the time stamp of a viewed entry
--* and add it to the users recent viewed list
--*
--------------------------------------------------------------------------------
procedure touch (
    p_page_id     in  number
  , p_entity_id   in  number   default null
  , p_user        in  varchar2 default sys_context('APEX$SESSION','APP_USER')
)
is
begin

  -- touching page_id for p_user, this will make it jump to the top.
  update tk_recent_views
     set viewed_on = sysdate
   where view_user = p_user
     and page_id = p_page_id
     and nvl(entity_id,-1) = nvl(p_entity_id, -1);

  if SQL%ROWCOUNT = 0 then
    -- if the page_id and entity was not in the list we add it.
    insert into tk_recent_views (
        view_user
      , page_id
      , entity_id
      , viewed_on
    ) values (
        p_user
      , p_page_id
      , p_entity_id
      , sysdate
    );

    -- something was added, see if we need to delete something
    remove_old_views(p_user);
  end if;

  -- Maintain the current_view
  current_view(p_page_id, p_entity_id, p_user);

end touch;




end tk_recent_views_api;
/
show errors
