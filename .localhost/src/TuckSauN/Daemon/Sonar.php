<?php

namespace TuckSauN\Daemon;

class Sonar extends AbstractDaemon
{
    const PID_FILE = '/Users/tugdual.saunier/Work/sonar//bin/macosx-universal-64/sonar.pid';

    public function start()
    {
        $command = '$HOME/Work/sonar/bin/macosx-universal-64/sonar.sh start';
        exec($command);
    }
}
