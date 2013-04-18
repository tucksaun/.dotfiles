<?php

namespace TuckSauN\Daemon;

class PostgreSQL extends AbstractDaemon
{
    const PID_FILE = '/usr/local/var/postgres/postmaster.pid';

    public function start()
    {
        exec('/usr/local/bin/pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start');
    }
}
