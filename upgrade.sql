
define prev_app_id = 51769

PRO .. adding tk_current_views.application_id
alter table tk_current_views add application_id number;

PRO .. Populating tk_current_views.application_id
update tk_current_views
   set application_id = &prev_app_id
 where application_id is null;

PRO .. Make tk_current_views.application_id mandatory
alter table tk_current_views modify application_id not null;

PRO .. Re-creating index for tk_current_views
drop index tk_current_views_u01;
create unique index tk_current_views_u01 on tk_current_views(application_id, page_id, entity_id)
/

-- -----------------------------------------------------------------------------
-- Optional Reordering TK_CURRENT_VIEWS to place application_id towards the top
-- alter table TK_CURRENT_VIEWS modify (APPLICATION_ID invisible);
-- alter table TK_CURRENT_VIEWS modify (APPLICATION_ID visible);
-- alter table TK_CURRENT_VIEWS modify (PAGE_ID invisible);
-- alter table TK_CURRENT_VIEWS modify (PAGE_ID visible);
-- alter table TK_CURRENT_VIEWS modify (ENTITY_ID invisible);
-- alter table TK_CURRENT_VIEWS modify (ENTITY_ID visible);
-- alter table TK_CURRENT_VIEWS modify (VIEWED_ON invisible);
-- alter table TK_CURRENT_VIEWS modify (VIEWED_ON visible);
-- alter table TK_CURRENT_VIEWS modify (VIEW_USER invisible);
-- alter table TK_CURRENT_VIEWS modify (VIEW_USER visible);


-- -----------------------------------------------------------------------------

PRO .. adding tk_recent_views.application_id
alter table tk_recent_views add application_id number;

PRO .. Populating tk_recent_views.application_id
update tk_recent_views
   set application_id = &prev_app_id
 where application_id is null;

PRO .. Make tk_recent_views.application_id mandatory
alter table tk_recent_views modify application_id not null;

PRO .. Adding index for tk_recent_views
create index tk_recent_views_i01 on tk_recent_views(application_id, view_user);



-- -----------------------------------------------------------------------------
-- Optional Reordering TK_RECENT_VIEWS to place application_id towards the top
-- alter table tk_recent_views modify (application_id invisible);
-- alter table tk_recent_views modify (application_id visible);
-- alter table tk_recent_views modify (view_user invisible);
-- alter table tk_recent_views modify (view_user visible);
-- alter table tk_recent_views modify (viewed_on invisible);
-- alter table tk_recent_views modify (viewed_on visible);
-- alter table tk_recent_views modify (page_id invisible);
-- alter table tk_recent_views modify (page_id visible);
-- alter table tk_recent_views modify (entity_id invisible);
-- alter table tk_recent_views modify (entity_id visible);
-- alter table tk_recent_views modify (created_by invisible);
-- alter table tk_recent_views modify (created_by visible);
-- alter table tk_recent_views modify (created_on invisible);
-- alter table tk_recent_views modify (created_on visible);
-- alter table tk_recent_views modify (updated_by invisible);
-- alter table tk_recent_views modify (updated_by visible);
-- alter table tk_recent_views modify (updated_on invisible);
-- alter table tk_recent_views modify (updated_on visible);



-- -----------------------------------------------------------------------------
alter table tk_recent_views modify created_on default sysdate;
alter table tk_recent_views modify created_by default
coalesce(
    sys_context('APEX$SESSION','app_user')
  , regexp_substr(sys_context('userenv','client_identifier'),'^[^:]*')
  , sys_context('userenv','session_user')
);


-- -----------------------------------------------------------------------------

create or replace trigger tk_recent_views_iu
before update
on tk_recent_views
referencing old as old new as new
for each row
begin
  :new.updated_on := sysdate;
  :new.updated_by := coalesce(
                         sys_context('APEX$SESSION','app_user')
                       , regexp_substr(sys_context('userenv','client_identifier'),'^[^:]*')
                       , sys_context('userenv','session_user')
                     );
end;
/


-- -----------------------------------------------------------------------------
@install/tk_current_view_tracking.sql


PROMPT .. tk_recent_views_api
@plsql/tk_recent_views_api.pls
@plsql/tk_recent_views_api.plb
