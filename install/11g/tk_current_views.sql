-- drop table tk_current_views purge
-- /
create table tk_current_views (
    id          number        primary key not null
  , page_id     number        not null
  , entity_id   number        not null
  , viewed_on   date          not null
  , view_user   varchar2(60)  not null
)
/

create unique index tk_current_views_u01 on tk_current_views(page_id, entity_id)
/

comment on table tk_current_views is 'Holds users recent page views by entity_id.';

create sequence tk_current_views_seq
  start with 1;
/

--------------------------------------------------------
--  DDL for Trigger tk_current_views_iu
--------------------------------------------------------
create or replace trigger tk_current_views_iu
before insert or update
on tk_current_views
referencing old as old new as new
for each row
begin
  if inserting then
    if :new.id is null then
      :new.id := tk_current_views_seq.nextval;
    end if;
    :new.created_on := sysdate;
    :new.created_by := coalesce(v('APP_USER'), user);
  elsif updating then
    :new.updated_on := sysdate;
    :new.updated_by := coalesce(v('APP_USER'), user);
  end if;
end;
/
alter trigger tk_current_views_iu enable;
