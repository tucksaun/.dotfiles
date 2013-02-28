<?php

require __DIR__.'/vendor/autoload.php';

$finder = new Symfony\Component\Finder\Finder();

$finder
    ->in(getenv('HOME').'/Work')
    ->directories()
    ->ignoreVCS(true)
    ->ignoreDotFiles(true)
    ->depth('<=1')
;

$dirs = array();
$blacklist = array('.bak', 'integration');
foreach ($finder as $dir) {
    foreach ($blacklist as $exclude) {
        if (strpos($dir, $exclude)) {
            continue 2;
        }
    }

    if (file_exists($dir.'/web')) {
        @list($dir, $project) = explode('/', $dir->getRelativePathname());
        if (!isset($dirs[$dir])) {
            $dirs[$dir] = array();
        }

        if (isset($dirs[$dir][''])) {
            continue;
        }

        if(isset($project)) {
            // project part of a subset
            $dirs[$dir][$project] = sprintf('http://%s.%s.dev', $project, $dir);
        } else {
            $dirs[$dir][''] = sprintf('http://%s.dev', $dir);
        }

    }
}

$utils = array(
    'PHPinfo' => '/phpinfo.php',
    'APC' => '/apc.php',
    'PMA' => '/phpmyadmin',
)
?>
<html>
    <head>
        <title>TuckSauN - Projects</title>
        <style type="text/css">
        </style>
    </head>
    <body>
        <h1>TuckSauN - Projects</h1>
        <h2>Utils</h2>
        <ul>
            <?php foreach ($utils as $name => $link) : ?>
                <li>
                    <a href="<?php echo $link ?>">
                        <?php echo $name ?>
                    </a>
                </li>
            <?php endforeach; ?>
        </ul>
        <h2>Projects</h2>
        <ul>
            <?php foreach ($dirs as $dirName => $projects) : ?>
                <li>
                    <?php if (count($projects) > 1): ?>
                    <h3>
                        <?php echo ucfirst(strtolower($dirName)) ?>
                    </h3>
                    <ul>
                        <?php foreach ($projects as $projetName => $link): ?>
                            <li>
                                <a href="<?php echo $link ?>">
                                    <?php echo ucfirst(strtolower($projetName)) ?>
                                </a>
                            </li>
                        <?php endforeach ?>
                    </ul>
                    <?php else: ?>
                    <a href="<?php echo reset($projects) ?>">
                        <?php
                            echo    ($projectName = key($projects)) .
                                    ('' != $projectName ? ' - ' : '') .
                                    ucfirst(strtolower($dirName))
                            ;
                        ?>
                    </a>
                    <?php endif; ?>
                </li>
            <?php endforeach; ?>
        </ul>
    </body>
</html>
