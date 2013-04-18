<?php

namespace TuckSauN\Daemon;

class Redis extends AbstractDaemon
{
    const PID_FILE = '/usr/local/var/run/redis.pid';

    public function start()
    {
        exec('redis-server /usr/local/etc/redis.conf');
    }
}
