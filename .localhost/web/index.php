<?php

define('ROOT_DIR', dirname(__DIR__));
define('CACHE_LIFE', 3600 * 4); // 24h
define('CACHE_PATH', ROOT_DIR.'/cache');
define('CACHE_FILE', sprintf('%s/%s.html', CACHE_PATH, isset($_GET['tool']) ? $_GET['tool'] : 'list'));

if ((time() - @filemtime(CACHE_FILE)) < CACHE_LIFE) {
  $response = file_get_contents(CACHE_FILE);
} else {
  $tools = array(
    'phpinfo' => array(
      'label' => 'PHPInfo',
      'url'   => '/phpinfo.php',
    ),
    'apc'     => array(
      'label' => 'APC',
      'url'   => '/apc.php',
    ),
    'pma'     => array(
      'label' => 'PHPMyAdmin',
      'url'   => '/phpmyadmin',
    ),
  );

  require ROOT_DIR.'/vendor/autoload.php';

  TuckSauN\Template::$TEMPLATE_DIR = ROOT_DIR.'/templates';
  $layout = new TuckSauN\Template('layout');
  $layout->utils = $tools;

  if (isset($_GET['tool'])) {
    $tool = trim($_GET['tool']);
    if (isset($tools[$tool])) {
      $template = new TuckSauN\Template('tool');
      $template->tool = $tools[$tool];
    } else {
      $template = new TuckSauN\Template('error404');
      $template->tool = $tool;
      define('DISABLE_CACHE', true);
      header('HTTP/1.0 404 Not Found', true, 404);
    }
  } else {
    $projects = (new TuckSauN\ProjectList\ConfigGenerator(getenv('HOME').'/Work'))->getProjects();

    $template = new TuckSauN\Template('list');
    $template->projects = $projects;
  }

  # Decorate the main template with the layout template
  $response = $template->decorateWith($layout);
  if (!defined('DISABLE_CACHE')) {
    file_put_contents(CACHE_FILE, $response);
  }
}

header('Content-Type: text/html; charset=utf-8');
echo $response;
