<?php

namespace TuckSauN\Daemon;

class Nginx extends AbstractDaemon
{
    const PID_FILE = '/usr/local/var/run/nginx.pid';

    public function isManageable()
    {
        return false;
    }

    public function start()
    {
        throw new \Exception('You can not turn on '.$this->getName());
    }

    public function stop()
    {
        throw new \Exception('You can not turn off '.$this->getName());
    }
}
