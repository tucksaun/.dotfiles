<?php

// $app['debug'] = true;

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

    file_put_contents(CACHE_FILE, $generator->dump());
}

$mailNotifier = new Sismo\Notifier\MailNotifier('tucksaun@gmail.com', '%status%', '%status%');
$notifier = new Sismo\Contrib\CrossFingerNotifier(array($mailNotifier));

require __DIR__.'/LocalProject.php';
return require CACHE_FILE;
