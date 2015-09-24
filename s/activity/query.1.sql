SELECT
    lpad(
        to_char(
            extract(
                epoch FROM clock_timestamp()-xact_start
            ),
            'FM999999990.000"s"'
        ),
        10
    ) as xact_t,
    lpad(
        to_char(
            extract(
                epoch FROM clock_timestamp()-query_start
            ),
            'FM999999990.000"s"'
        ),
        10
    ) as query_t,
    pid as pid,
    case when waiting then 'LOCK'::text else '    '::text end as lock,
    coalesce( client_addr::TEXT, '[local]') || ':' || client_port as client,
    array_to_string(
        ARRAY( SELECT (regexp_matches( query, '(.{1,' || least( 255, :COLUMNS - 67 )::TEXT || '})', 'g'))[1] ),
        E' --\n'
    ) as query
FROM
    pg_stat_activity
WHERE
    state <> 'idle'
    AND pid <> pg_backend_pid()
    AND datname = current_database()
ORDER BY
    xact_start
;
