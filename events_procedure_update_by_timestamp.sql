create or replace procedure amp_events_table_refresh()
returns varchar
language sql
as
$$
begin
    insert into amp_events (
    select
        e."uuid" as event_id,
        e."event_id" as session_event_order,
        e."session_id" as session_id,
        el."id" as events_list_id,
        e."event_time" as event_time,
        hash(e."event_properties") as event_properties_id,
        hash(e."user_properties") as user_properties_id
    from amplitude_events_raw as e
    left join amplitude_events_list_raw as el
        on e."event_type" = el."name"
    -- limit 1
    where e."event_time" > (
        select max(ec.event_time) as latest_date
        from amp_events as ec
    )
);
return 'Insert completed: amp_events_table_refresh';
end;
$$
;