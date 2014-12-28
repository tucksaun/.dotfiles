<?php

namespace TuckSauN\Daemon;

class RabbitMQ extends AbstractDaemon
{
    const PID_FILE = '/usr/local/var/lib/rabbitmq/mnesia/rabbit@localhost.pid';

    public function start()
    {
        $command = sprintf('/usr/local/sbin/rabbitmq-server >> /usr/local/var/log/rabbitmq.log 2>&1 &');
        exec($command);
    }

    public function stop()
    {
        $command = sprintf('/usr/local/sbin/rabbitmqctl stop %s', static::getPidFileName());
        exec($command);
    }
}
