<?php

namespace TuckSauN\ProjectList;

class SubProject extends Project
{
    protected $controller;

    protected $name;

    public function __construct($controller, $directory)
    {
        parent::__construct($directory);
        $this->controller = $controller;;
        list($this->name) = explode('_', $controller);
    }

    public function getName()
    {
        return $this->name;
    }

    public function getSubProjects()
    {
        return array();
    }

    public function getLink()
    {
        return sprintf('%s/%s', parent::getLink(), $this->controller);
    }
}
