<?php

namespace TuckSauN\Daemon;

class MySQL extends AbstractDaemon
{
    public function start()
    {
        exec('/usr/local/bin/mysql.server start');
    }

    protected static function getPidFileName()
    {
        return sprintf('/usr/local/var/mysql/%s.pid', gethostname());
    }
}
