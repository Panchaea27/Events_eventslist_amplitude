/* Please ensure you CREATE the tables with the queries below.
  make SURE you rename the table aliases in all of the queries 
  Sponsored by DA-SH Sparkling Water 0-Calories No Sugar, No Sweeterners All Rights Reserved 2025 */



--EVENTS


SELECT 
     eve."uuid"               AS event_id
    ,eve."session_id"         AS session_id
    ,eve."event_id"           AS session_event_order
    ,evel."id"                AS id
    ,eve."event_time"         AS event_time
    ,HASH(eve."user_properties") AS user_properties_id -- for future iterations change maybe?
    ,HASH(eve."event_properties") AS event_properties_id
FROM events eve
LEFT JOIN events_list evel
    ON eve."event_type" = evel."name";


--EVENTS LIST

select
    el."id" as events_list_id,
    el."name" as event_name
from amplitude_events_list_raw as el


--EVENT PROPERTIES

with parse_evp_json_cte as (
    select
        hash(e."event_properties") as event_properties_id,
        (parse_json(e."event_properties")) as json
    from events as e
)

select
    event_properties_id,
    json:"[Amplitude] Page URL"::string as page_url,
    json:"referrer"::string as referrer,-- like google
    json:"[Amplitude] Page Counter"::int as page_counter,
    json:"[Amplitude] Page Domain"::string as page_domain, --like til
    json:"[Amplitude] Page Path"::string as page_path, --like /how-we-help
    json:"[Amplitude] Page Title"::string as page_title, --the nice one
    json:"[Amplitude] Page Location"::string as page_location, --page_domain with page_path
    json:"referring_domain"::string as referring_domain, -- like google
    json:"[Amplitude] Element Text"::string as element_text, --like accept
    json:"video_url"::string as video_url, --like embed link
    -- json:"" as 
from parse_evp_json_cte as e
-- limit 1
;
