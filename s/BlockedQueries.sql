-- Bloked Queries!menuwait
SELECT
    bl.relation as locked_relation,
    bl.mode as locked_mode,
    bl.pid as blocked_pid,
    a.usename as blocked_user,
    a.query as blocked_statement,
    a.client_addr as blocked_client_addr,
    age(now(),a.query_start) as blocked_query_age,
    kl.pid as blocking_pid,
    ka.usename as blocking_user,
    ka.query as blocking_statement,
    ka.client_addr as blocking_client_addr,
    now() - ka.query_start as blocking_query_age,
    now() - ka.xact_start as blocking_xact_age
FROM pg_catalog.pg_locks bl
     JOIN pg_catalog.pg_stat_activity a
     on bl.pid = a.pid
     JOIN pg_catalog.pg_locks kl
          JOIN pg_catalog.pg_stat_activity ka
          on kl.pid = ka.pid
     on bl.transactionid = kl.transactionid and bl.pid != kl.pid
WHERE not bl.granted  
ORDER by blocking_xact_age desc ;
