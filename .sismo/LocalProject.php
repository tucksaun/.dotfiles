<?php

use Symfony\Component\Process\Process;

class LocalProject extends \Sismo\Project
{
    /**
     * Sets the branch of the project we are interested in.
     *
     * @param string $branch The branch name
     */
    public function setBranch($branch)
    {
        throw new \RuntimeException('Branch setting is not authorized for LocalProjects.');
    }

    /**
     * Gets the project branch name.
     *
     * @return string The branch name
     */
    public function getBranch()
    {
        $process = new Process("git rev-parse --abbrev-ref HEAD", $this->getRepository());
        $process->run();

        if (!$process->isSuccessful()) {
            throw new \RuntimeException(sprintf("Impossible to determine current branch for \"%s\" project", $this->getName()));
        }

        return trim($process->getOutput());
    }
}
