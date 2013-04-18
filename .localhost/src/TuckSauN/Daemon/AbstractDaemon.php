<?php

namespace TuckSauN\Daemon;

abstract class AbstractDaemon
{
    const PID_FILE = '/usr/local/var/run/nginx.pid';

    public function getName()
    {
        return substr(get_class($this), 16);
    }

    public function isManageable()
    {
        return true;
    }

    public function isStarted()
    {
        return file_exists(static::getPidFileName()) && static::processExists($this->getPid());
    }

    abstract public function start();

    public function stop()
    {
        posix_kill($this->getPid(), SIGTERM);
    }

    protected static function getPidFileName()
    {
        return static::PID_FILE;
    }

    protected function getPid()
    {
        $f = fopen(static::getPidFileName(), 'r');
        $pid = fgets($f);
        fclose($f);

        return trim($pid);
    }

    protected static function processExists($pid) {
        exec("\ps ax | \grep $pid 2>&1", $output);
        while( list(,$row) = each($output) ) {
            $row = trim($row);
            $row_array = explode(" ", $row);
            $check_pid = $row_array[0];
            if($pid == $check_pid) {
              return true;
            }
        }

        return false;
    }
}
