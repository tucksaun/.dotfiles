<?php

namespace TuckSauN\Daemon;

class MongoDB extends AbstractDaemon
{
    const PID_FILE = '/usr/local/var/run/mongodb.pid';

    public function start()
    {
        exec('mongod');
    }
}
