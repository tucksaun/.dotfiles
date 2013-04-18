<?php

use TuckSauN\Daemon;

define('WEB_DIR', __DIR__);
define('ROOT_DIR', dirname(__DIR__));
define('CACHE_LIFE', 3600 * 4); // 24h
define('CACHE_PATH', ROOT_DIR.'/cache');
define('CACHE_FILE', sprintf('%s/%s.html', CACHE_PATH, isset($_GET['tool']) ? $_GET['tool'] : 'list'));
if ($_SERVER['REQUEST_METHOD'] !== 'GET' || isset($_GET['daemon-control'])) {
  define('DISABLE_CACHE', true);
}
// define('DISABLE_CACHE', true);

if (!defined('DISABLE_CACHE') && (time() - @filemtime(CACHE_FILE)) < CACHE_LIFE) {
  $response = file_get_contents(CACHE_FILE);
} else {
  $tools = array(
    'phpinfo'   => array(
      'iframe' => false,
      'label'  => 'PHPInfo',
      'url'    => '/phpinfo.php',
    ),
    'apc'       => array(
      'iframe' => false,
      'label'  => 'APC',
      'url'    => '/apc.php',
    ),
    'pma'       => array(
      'iframe' => true,
      'label'  => 'PHPMyAdmin',
      'url'    => '/phpmyadmin',
    ),
    'pgm' => array(
      'iframe' => true,
      'label'  => 'phpPgAdmin',
      'url'    => '/phppgadmin/',
    ),
    'rockmongo' => array(
      'iframe' => true,
      'label'  => 'RockMongo',
      'url'    => '/rockmongo',
    ),
    'phpRedisAdmin' => array(
      'iframe' => true,
      'label'  => 'phpRedisAdmin',
      'url'    => '/redis',
    ),
    'sismo'     => array(
      'iframe' => true,
      'label'  => 'Sismo',
      'url'    => 'http://sismo.dev',
    ),
    'hudson'     => array(
      'iframe' => true,
      'label'  => 'Hudson',
      'url'    => 'http://localhost:8080',
    ),
    'sonar'     => array(
      'iframe' => true,
      'label'  => 'Sonar',
      'url'    => 'http://localhost:9000/',
    ),
    'solr'     => array(
      'iframe' => true,
      'label'  => 'Solr',
      'url'    => 'http://localhost:8983',
    ),
  );

  require ROOT_DIR.'/vendor/autoload.php';

  TuckSauN\Template::$TEMPLATE_DIR = ROOT_DIR.'/templates';

  $getDaemons = function() {
    return array(
      new Daemon\Nginx,
      new Daemon\PhpFpm,
      new Daemon\MySQL,
      new Daemon\PostgreSQL,
      new Daemon\MongoDB,
      new Daemon\Redis,
      new Daemon\Sonar,
      new Daemon\Hudson,
      new Daemon\Solr,
    );
  };

  if (isset($_GET['daemon-control'])) {
    foreach ($getDaemons() as $daemon) {
      if ( $daemon->getName() === $_GET['daemon'] ) {
        if ('start' === $_GET['action']) {
          $daemon->start();
          while(!$daemon->isStarted()) {
            usleep(100000); // Sleep for 100 miliseconds;
          }
        } elseif ('stop' === $_GET['action']) {
          $daemon->stop();
          while($daemon->isStarted()) {
            usleep(100000); // Sleep for 100 miliseconds;
          }
        }

        break;
      }
    }

    header('Location: /');
    exit;
  } elseif (isset($_GET['tool'])) {
    $tool = trim($_GET['tool']);

    if ('daemons' === $tool) {
      define('DISABLE_CACHE', true);
      $template = new TuckSauN\Template('daemons');
      $template->disableDecoration();
      $template->daemons = $getDaemons();
    } elseif (isset($tools[$tool])) {
      $template = new TuckSauN\Template('tool');
      $tools[$tool]['name'] = $tool;
      $tool = $tools[$tool];
      $template->tool = $tool;
      if (!$tool['iframe']) {
        define('DISABLE_CACHE', true);
      }
    } else {
      $template = new TuckSauN\Template('error404');
      define('DISABLE_CACHE', true);
      header('HTTP/1.0 404 Not Found', true, 404);
    }
  } else {
    $generator = new TuckSauN\ProjectList\ConfigGenerator(getenv('HOME').'/Work');
    $projects = $generator->getProjects();

    $template = new TuckSauN\Template('list');
    $template->projects = $projects;
  }

  $layout = new TuckSauN\Template('layout');
  $layout->utils = $tools;
  # Decorate the main template with the layout template
  $response = $template->decorateWith($layout);
  if (!defined('DISABLE_CACHE')) {
    file_put_contents(CACHE_FILE, $response);
  }
}

header('Content-Type: text/html; charset=utf-8');
echo $response;
