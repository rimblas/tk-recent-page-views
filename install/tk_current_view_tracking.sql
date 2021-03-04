-- drop table tk_current_views purge
-- /
create table tk_current_view_tracking (
    application_id number        not null
  , page_id        number        not null
  , constraint tk_current_view_tracking_pk primary key (application_id, page_id)
)
organization index
/


comment on table tk_current_view_tracking is 'Pagess where current view tracking is enabled';


