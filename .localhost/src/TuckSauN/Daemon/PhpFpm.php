<?php

namespace TuckSauN\Daemon;

class PhpFpm extends AbstractDaemon
{
    const PID_FILE = '/usr/local/var/run/php-fpm.pid';

    public function getName()
    {
        return 'PHP FPM';
    }

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
