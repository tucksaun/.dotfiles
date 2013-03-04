<?php

// $app['debug'] = true;

use Sismo\Contrib\GrowlNotifier;

define('CACHE_FILE', $app['data.path'].'/cache/config.cache.php');
define('CACHE_LIFE', 7200); // 2h

if ( (time() - @filemtime(CACHE_FILE)) > CACHE_LIFE || $app['debug']) {
    require __DIR__.'/SismoConfigGenerator.php';

    $generator = new SismoConfigGenerator();
    $finder = Symfony\Component\Finder\Finder::create()
        ->directories()
        ->depth('< 1')
        ->in(getenv('HOME').'/Work/tucknet')
        ->in(getenv('HOME').'/Work')
        ->notName('*.bak')
        ->filter(function($directory){
            return !$directory->isLink() && is_dir($directory->getPathname().'/.git');
        })
    ;

    clearstatcache();
    foreach ($finder as $directory) {
        $generator->addPath($directory);
    }

    if (!is_dir(dirname(CACHE_FILE))) {
        mkdir(dirname(CACHE_FILE), 0755, true);
    }

    file_put_contents(CACHE_FILE, $generator->dump());
}

$notifier = new GrowlNotifier('sismo', array(
    GrowlNotifier::NOTIFY_SUCCESS => array(
        'icon'   => getenv('HOME').'/.icons/jenkins-logo.png',
        'sticky' => false,
    ),
    GrowlNotifier::NOTIFY_FAILURE => array(
        'icon'  => getenv('HOME').'/.icons/jenkins-logo.png',
    )
), '', array(
    'protocol' => 'gntp',
    'AppIcon'  => getenv('HOME').'/.icons/jenkins-logo.png',
));

require __DIR__.'/LocalProject.php';
return require CACHE_FILE;
