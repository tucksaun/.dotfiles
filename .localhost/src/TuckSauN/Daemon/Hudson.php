<?php

namespace TuckSauN\Daemon;

class Hudson extends AbstractDaemon
{
    const PID_FILE = '/usr/local/var/run/hudson.pid';

    public function start()
    {
        $command = sprintf('java -jar $HOME/Work/hudson.war >> /usr/local/var/log/hudson.log 2>&1 &
echo $! >%s', $this->getPidFileName());
        exec($command);
    }
}
