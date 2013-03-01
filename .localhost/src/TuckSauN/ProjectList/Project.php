<?php

namespace TuckSauN\ProjectList;

class Project extends AbstractProject
{
    protected $urlPattern = 'http://%s.dev';

    public function getWebRoot()
    {
        if (file_exists($this->directory.'/web')) {
            return $this->directory.'/web';
        }

        return $this->directory;
    }

    public function getSlug()
    {
        return $this->directory->getRelativePathname();
    }

    public function getName()
    {
        return $this->directory->getRelativePathname();
    }

    public function setUrlPattern($pattern)
    {
        $this->urlPattern = $pattern;
    }

    public function getLink()
    {
        return sprintf($this->urlPattern, strtolower($this->directory->getRelativePathname()), '');
    }

    protected function findSubProjects()
    {
        $subProjects = array();

        foreach ($this->findControllers() as $controller) {
            $controller = str_replace($this->getWebRoot().'/', '', $controller);
            $subProjects[] = new SubProject($controller, $this->directory);
        }

        return $subProjects;
    }

    protected function findControllers()
    {
        $controllers = glob($this->getWebRoot().'/*_dev.php');

        return (count($controllers) > 1) ? $controllers : array();
    }
}
