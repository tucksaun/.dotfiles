<?php

namespace TuckSauN\ProjectList;

class Project extends AbstractProject
{
    protected $urlPattern = 'http://%s.dev%s';

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
        $controller = str_replace($this->getWebRoot(), '', $this->findMainController());

        return sprintf($this->urlPattern, strtolower($this->directory->getRelativePathname()), $controller);
    }

    public function getFavicon()
    {
        if (!file_exists($this->getWebRoot().'/favicon.ico')) {
            return '/favicon.ico';
        }
        return sprintf($this->urlPattern, strtolower($this->directory->getRelativePathname()), '/favicon.ico');
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

    protected function findMainController()
    {
        $controllers = glob($this->getWebRoot().'/*_dev.php');

        return reset($controllers);
    }

    protected function findControllers()
    {
        $controllers = glob($this->getWebRoot().'/*_dev.php');

        return (count($controllers) > 1) ? $controllers : array();
    }
}
