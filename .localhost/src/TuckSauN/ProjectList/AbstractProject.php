<?php

namespace TuckSauN\ProjectList;

abstract class AbstractProject
{
    protected $directory;
    protected $subProjects;

    public function __construct($directory)
    {
        $this->directory = $directory;
    }

    public function hasSubProjects()
    {
        return 1 < count($this->getSubProjects());
    }

    public function getSubProjects()
    {
        if (!$this->subProjects) {
            $this->subProjects = $this->findSubProjects();
        }

        return $this->subProjects;
    }

    abstract public function getName();

    abstract public function getSlug();

    abstract protected function findSubProjects();
}
