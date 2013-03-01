<?php

namespace TuckSauN\ProjectList;

class ProjectCollection extends AbstractProject
{
    public function getName()
    {
        if (!$this->hasSubProjects()) {
            return sprintf('%s - %s', $this->directory->getBasename(), reset($this->subProjects)->getName());
        }

        return $this->directory->getBasename();
    }

    public function getSlug()
    {
        return $this->directory->getBasename();
    }

    public function getLink()
    {
        return reset($this->subProjects)->getLink();
    }

    protected function findSubProjects()
    {
        $projects = (new ConfigGenerator($this->directory->getRealPath()))->getProjects(0);

        foreach ($projects as $project) {
            $project->setUrlPattern(sprintf('http://%%s.%s.dev', $this->getSlug()));
        }

        return $projects;
    }
}
