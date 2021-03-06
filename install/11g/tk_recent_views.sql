create table tk_recent_views (
    id          number        primary key not null
  , view_user   varchar2(60)  not null
  , viewed_on   date          not null
  , page_id     number        not null
  , entity_id   number
  , created_by  varchar2(60)  not null
  , created_on  date          not null
  , updated_by  varchar2(60)
  , updated_on  date
)
enable primary key using index
/

comment on table tk_recent_views is 'Holds users recent page views.'
/

create sequence tk_recent_views_seq
  start with 1;
/

--------------------------------------------------------
--  DDL for Trigger tk_recent_views_iu
--------------------------------------------------------
create or replace trigger tk_recent_views_iu
before insert or update
on tk_recent_views
referencing old as old new as new
for each row
begin
  if inserting then
    if :new.id is null then
      :new.id := tk_recent_views_seq.nextval;
    end if;
    :new.created_on := sysdate;
    :new.created_by := coalesce(v('APP_USER'), user);
  elsif updating then
    :new.updated_on := sysdate;
    :new.updated_by := coalesce(v('APP_USER'), user);
  end if;
end;
/
alter trigger tk_recent_views_iu enable;
