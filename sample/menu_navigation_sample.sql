
-- This is a real life example of how the Recently Used table
-- was used to enhanced the menu navigation of a page.
-- See menu_with_recently_used.gif to see it in action.

select lvl
     , label_value
     , apex_util.prepare_url('f?p=' || :APP_ID || ':' || page_id || ':' || :APP_SESSION || ':' || request || ':' || :DEBUG || ':' || clear_url || ':' || params) target
     , is_current
     , image, image_att, image_alt_attr
     , a1
from (
select lvl
     , label_value
     , page_id
     , clear_url
     , request
     , params
     , is_current
     , image, image_att, image_alt_attr
     , a1
     , seq
     , viewed_on
from cw_main_tabs_v
)
order by seq, viewed_on desc, lvl
/

create or replace view cw_main_tabs_v
as
with p as (select nv('APP_ID') application_id, v('APP_PAGE_ID') app_page_id, v('APP_USER') app_user from dual)
select 1 lvl
     , 'Home' label_value
     , 1 page_id
     , '' clear_url
     , '' request
     , '' params
     , case when p.app_page_id < 200 then 'YES' else 'NO' end is_current
     , '' image, null image_att, null image_alt_attr
     , 'navhome' a1
     , '0' seq
     , to_date(null) viewed_on
from dual, p
union all
select 1 lvl
     , 'Queue' label_value
     , 200 page_id
     , '' clear_url
     , '' request
     , '' params
     , case when p.app_page_id >= 200 and p.app_page_id < 300 then 'YES' else 'NO' end is_current
     , '' image, null a1, null att2
     , 'navclaim' a1
     , '1' seq
     , to_date(null)
from dual, p
union all
select 2 lvl
     , '#' || c.cw_claim_no || ' ' || substr(c.claim_type,4,1) || ': ' || cl.short_name label_value
     , 210 page_id
     , '210' clear_url
     , '' request
     , 'P210_ID,P210_CALLING_PAGE:' || r.entity_id || ',' || p.app_page_id params
     , 'NO' is_current
     , null, null, null
     , '' a1
     , '1a' seq
     , r.viewed_on
from cw_recent_views r
   , cw_claim_headers c
   , cw_clients cl
   , p
where r.application_id = p.application_id
  and r.page_id = 210
  and r.view_user = p.app_user
  and r.entity_id = c.id
  and c.client_id = cl.id
union all
select 1 lvl
     , 'Clients' label_value
     , 300 page_id
     , '' clear_url
     , '' request
     , '' params
     , case when p.app_page_id >= 300 and p.app_page_id < 360 then 'YES' else 'NO' end is_current
     , null, null, null
     , 'navclients' a1
     , '3' seq
     , to_date(null)
from dual, p
union all
select 2 lvl
     , c.client_short_name label_value
     , 310 page_id
     , '310' clear_url
     , '' request
     , 'P310_ID,P310_CALLING_PAGE:' || r.entity_id || ',' || p.app_page_id params
     , 'NO', null, null, null
     , '' a1
     , '3a'
     , r.viewed_on
from cw_recent_views r
   , cw_clients_v c
   , p
where r.application_id = p.application_id
  and r.page_id = 310
  and r.view_user = p.app_user
  and r.entity_id = c.client_id
union all
select 1 lvl
     , 'Providers' label_value
     , 360 page_id
     , '' clear_url
     , '' request
     , '' params
     , case when p.app_page_id >= 360 and p.app_page_id < 399 then 'YES' else 'NO' end is_current
     , null, null, null
     , 'navprov' a1
     , '4' seq
     , to_date(null)
from dual, p
union all
select 2 lvl
     , substr(prov.name,1,40) label_value
     , 365 page_id
     , '365' clear_url
     , '' request
     , 'P365_ID,P365_CALLING_PAGE:' || r.entity_id || ',' || p.app_page_id params
     , 'NO', null, null, null
     , '' a1
     , '4a'
     , r.viewed_on
from cw_recent_views r
   , cw_providers prov
   , p
where r.application_id = p.application_id
  and r.page_id = 365
  and r.view_user = p.app_user
  and r.entity_id = prov.id
union all
select 1 lvl
     , 'Cases' label_value
     , 800 page_id
     , '' clear_url
     , '' request
     , '' params
     , case when p.app_page_id >= 800 and p.app_page_id < 900 then 'YES' else 'NO' end is_current
     , null, null, null
     , 'navcases' a1
     , '6' seq
     , to_date(null)
from dual, p
union all
select 2 lvl
     , 'Case #' || c.case_no || ' -> ' || substr(c.phase_name,1,30) label_value
     , 810 page_id
     , '810' clear_url
     , '810' request
     , 'P810_CASE_ID,P810_MANUAL_FLAG,P810_CALLING_PAGE:' || r.entity_id || ',' || c.manual_flag || ',' || p.app_page_id params
     , 'NO', null, null, null
     , '' a1
     , '6a'
     , r.viewed_on
from cw_recent_views r
   , cw_cases_simple_v c
   , p
where r.application_id = p.application_id
  and r.page_id = 810
  and r.view_user = p.app_user
  and r.entity_id = c.case_id
union all
select 1 lvl
     , 'Codes' label_value
     , 610 page_id
     , '' clear_url
     , '' request
     , '' params
     , case when p.app_page_id >= 600 and p.app_page_id < 700 then 'YES' else 'NO' end is_current
     , null, null, null
     , 'navcodes' a1
     , '7' seq
     , to_date(null)
from dual, p
union all
select 2 lvl
     , substr(l.name,1,40) label_value
     , 620 page_id
     , '620' clear_url
     , '' request
     , 'P620_ID,P620_CALLING_PAGE:' || r.entity_id || ',' || p.app_page_id params
     , 'NO', null, null, null
     , '' a1
     , '7a'
     , r.viewed_on
from cw_recent_views r
   , cw_all_list_headers l
   , p
where r.application_id = p.application_id
  and r.page_id = 620
  and r.view_user = p.app_user
  and r.entity_id = l.id
union all
select 1 lvl
     , 'Processing' label_value
     , 700 page_id
     , '' clear_url
     , '' request
     , '' params
     , case when p.app_page_id >= 700 and p.app_page_id < 800 then 'YES' else 'NO' end is_current
     , null, null, null
     , 'navproc' a1
     , '8' seq
     , to_date(null)
from dual, p
union all
select 1 lvl
     , 'Rules' label_value
     , 500 page_id
     , '' clear_url
     , '' request
     , '' params
     , case when p.app_page_id >= 500 and p.app_page_id < 600 then 'YES' else 'NO' end is_current
     , null, null, null
     , 'navrules' a1
     , '9' seq
     , to_date(null)
from dual, p
union all
select 2 lvl
     , substr(u.rule_number || nvl2(u.rule_number, ' - ', '') || u.name,1,40) label_value
     , 510 page_id
     , '510' clear_url
     , '' request
     , 'P510_ID,P510_CALLING_PAGE:' || r.entity_id || ',' || p.app_page_id params
     , 'NO', null, null, null
     , '' a1
     , '9a'
     , r.viewed_on
from cw_recent_views r
   , cw_rules u
   , p
where r.application_id = p.application_id
  and r.page_id = 510
  and r.view_user = p.app_user
  and r.entity_id = u.id
union all
select 1 lvl
     , 'Reports' label_value
     , 1000 page_id
     , '' clear_url
     , '' request
     , '' params
     , case when p.app_page_id >= 1000 and p.app_page_id < 2000 then 'YES' else 'NO' end is_current
     , null, null, null
     , 'navrep' a1
     , 'R' seq
     , to_date(null)
from dual, p
union all
select 2 lvl
     , page.page_title label_value
     , r.page_id page_id
     , '' clear_url
     , '' request
     , case when r.page_id in (1060, 1080)
         then 'P' || r.page_id || '_CALLING_PAGE:' || p.app_page_id
       else
         ''
       end params
     , 'NO', null, null, null
     , '' a1
     , 'Ra'
     , r.viewed_on
from cw_recent_views r
   , apex_application_pages page
   , p
where page.application_id = p.application_id
  and page.page_id = r.page_id
  and r.application_id = p.application_id
  and r.page_id between 1001 and 4999
  and r.view_user = p.app_user
/
