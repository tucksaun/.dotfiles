<?php

define('CACHE_FILE', __DIR__.'/cache/projects_list.cache.html');
define('CACHE_LIFE', 3600 * 4); // 24h
if ((time() - @filemtime(CACHE_FILE)) < CACHE_LIFE) {
    return include CACHE_FILE;
} else {
    require __DIR__.'/vendor/autoload.php';
    $projects = (new TuckSauN\ProjectList\ConfigGenerator(getenv('HOME').'/Work'))->getProjects();

    $utils = array(
        'PHPinfo' => '/phpinfo.php',
        'APC'     => '/apc.php',
        'PMA'     => '/phpmyadmin',
    );
    ob_start();
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
            <?php foreach ($projects as $project): ?>
                <li>
                    <?php if ($project->hasSubProjects()): ?>
                        <h3><?php echo $project->getName() ?></h3>
                        <ul>
                        <?php foreach ($project->getSubProjects() as $subProject): ?>
                            <li>
                                <a href="<?php echo $subProject->getLink() ?>"><?php echo $subProject->getName() ?></a>
                            </li>
                        <?php endforeach; ?>
                        </ul>
                    <?php else: ?>
                        <a href="<?php echo $project->getLink() ?>"><?php echo $project->getName() ?></a>
                    <?php endif; ?>
                </li>
            <?php endforeach; ?>
        </ul>
    </body>
</html>
<?php
    $output = ob_get_flush();
    file_put_contents(CACHE_FILE, $output);
}
