<?php

namespace TuckSauN\ProjectList;

use Symfony\Component\Finder\Finder;

class ConfigGenerator
{
    protected $workingDir;

    protected $blacklistRules;

    protected $projects = array();

    public function __construct($workingDir, $blacklistRules = array('/\.bak/', '/\.tmp/', '/integration/'))
    {
        if (!is_dir($workingDir)) {
            throw new \InvalidArgumentException(sprintf('"%s" is not a valid directory.', $workingDir));
        }

        $this->projects       = array();
        $this->workingDir     = $workingDir;
        $this->blacklistRules = $blacklistRules;
    }

    public function getProjects($maxDepth = 1)
    {
        if (!$this->projects) {
            for ($level = 0; $level <= $maxDepth; $level++) {
                $this->findAllPossibleProjects($level);
            }
        }

        return $this->projects;
    }

    public function dump($dest)
    {
        file_put_contents($dest, sprintf("<?php return %s;", var_export($this->getProjects(), true)));
    }

    protected function findAllPossibleProjects($level = 0)
    {
        $finder = new Finder();

        $directories = $finder
            ->in($this->workingDir)
            ->directories()
            ->ignoreVCS(true)
            ->ignoreDotFiles(true)
            ->depth(sprintf('==%u', $level))
            ->filter(function(\SplFileInfo $file) {
                return $this->isDirectoryAllowed($file);
            })
            ->filter(function(\SplFileInfo $file) {
                return $this->isDirectoryProject($file);
            })
        ;

        $this->hydrateProjects($directories, $level);

        return $this;
    }

    public function hydrateProjects($directories, $level)
    {
        foreach ($directories as $directory) {
            if ($level > 0) {
                $directory = new \SplFileInfo(dirname($directory->getRealPath()));
                $project = new ProjectCollection($directory);
            } else {
                $project = new Project($directory);
            }
            if (!isset($this->projects[$project->getSlug()])) {
                $this->projects[$project->getSlug()] = $project;
            }
        }
    }

    protected function isDirectoryAllowed(\SplFileInfo $directory)
    {
        foreach ($this->blacklistRules as $rule) {
            if (preg_match($rule, $directory)) {
                return false;
            }
        }

        return true;
    }

    protected function isDirectoryProject(\SplFileInfo $directory)
    {
        if (
            is_dir($directory.'/web') ||
            file_exists($directory.'/index.php') ||
            (is_dir($directory.'/dev') && is_dir($directory.'/prod')) ||
            is_dir($directory.'/htdocs') ||
            is_dir($directory.'/public_html')
        ) {
            return true;
        }

        return false;
    }
}
