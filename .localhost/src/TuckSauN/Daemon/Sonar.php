<?php

namespace TuckSauN\Daemon;

class Sonar extends AbstractDaemon
{
    private $database;
    const PID_FILE = '/Users/tugdual.saunier/Work/sonar//bin/macosx-universal-64/sonar.pid';

    public function __construct(MySQL $database)
    {
        $this->database = $database;
    }

    public function start()
    {
        if (!$this->database->isStarted()) {
            $this->database->start();
            while(!$this->database->isStarted()) {
              usleep(100000); // Sleep for 100 miliseconds;
            }

        }

        $command = '$HOME/Work/sonar/bin/macosx-universal-64/sonar.sh start';
        exec($command);
    }
}
