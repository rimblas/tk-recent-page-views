-- drop table tk_current_views purge
-- /
create table tk_current_views (
    id             number        generated by default on null as identity (start with 1) primary key not null
  , application_id number        not null
  , page_id        number        not null
  , entity_id      number        not null
  , viewed_on      date          not null
  , view_user      varchar2(60)  not null
)
/

create unique index tk_current_views_u01 on tk_current_views(application_id, page_id, entity_id)
/

comment on table tk_current_views is 'Holds users recent page views by entity_id.';


