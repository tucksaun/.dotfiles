<?php

namespace TuckSauN\Daemon;

class Solr extends AbstractDaemon
{
    const PID_FILE = '/usr/local/var/run/solr.pid';

    public function start()
    {
        $command = sprintf('solr ~/.solr >> /usr/local/var/log/solr.log 2>&1 &
echo $! >%s', $this->getPidFileName());
        exec($command);
    }
}
