SELECT
    l.*
FROM
    pg_locks l
    join pg_stat_activity a on l.pid = a.pid
WHERE
    a.datname = current_database()
;
