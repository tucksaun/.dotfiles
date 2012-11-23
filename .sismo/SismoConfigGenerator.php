<?php

class SismoConfigGenerator
{
    const TEMPLATE = <<<EOF
%array_key% => (new LocalProject(%name%))
    ->setRepository(%path%)
    ->setSlug(%slug%)
    ->setCommand(%command%)
    ->addNotifier(\$notifier),

EOF
    ;

    static $poolCommands = array(
        'vendors'   => array(
            'deps'          => 'php bin/vendors install',
            'composer.json' => 'composer install --dev',
            'config.m4'     => 'phpize && ./configure',
        ),
        'tests'     => array(
            'Makefile'           => 'make test',
            'tests.sh'           => 'sh tests.sh',
            'run-tests.sh'       => 'sh run-tests.sh',
            'app'                => 'phpunit -c app/',
            'phpunit.xml.dist'   => 'phpunit',
            'phpunit.xml'        => 'phpunit',
            'lib/vendor/symfony' => 'php symfony test:all',
        ),
    );

    protected $paths = array();

    public function addPath(\SplFileInfo $directory)
    {
        $this->paths[] = $directory;

        return $this;
    }

    public function dump()
    {
        $configs = array();

        foreach ($this->paths as $index => $path) {
            $configs[] = $this->generateProjectConfig($path, $index);
        }

        return sprintf('<?php

return \SplFixedArray::fromArray(array(
%s
));
', implode("\n", $configs));
    }

    public function escape($value)
    {
        return var_export($value, true);
    }

    protected function generateProjectConfig(\SplFileInfo $directory, $index = 0)
    {
        $values = array_map(array($this, 'escape'), $this->getProjectValues($directory, $index));

        return strtr(self::TEMPLATE, $values);
    }

    protected function getProjectCommand($path)
    {
        $commands = array();
        foreach (self::$poolCommands as $pool) {
            foreach ($pool as $file => $command) {
                if(file_exists($path.'/'.$file)) {
                    $commands[] = $command;
                    break;
                }
            }
        }

        return trim(implode(";\n", $commands));
    }

    protected function getProjectValues(\SplFileInfo $directory, $index = 0)
    {
        $path = $directory->getPathname();
        $slug = $directory->getFilename();

        $descriptionFile = sprintf('%s/.git/description', $path);
        $description     = false;

        if (file_exists($descriptionFile)) {
            $description = trim(file_get_contents($directory->getPathname().'/.git/description'));
        }

        if (!$description || FALSE !== strpos($description, 'Unnamed repository')) {
            $description = $slug;
        }

        return array(
            '%array_key%' => $index,
            '%name%'      => $description,
            '%path%'      => $path,
            '%slug%'      => $slug,
            '%command%'   => $this->getProjectCommand($path),
        );
    }
}
