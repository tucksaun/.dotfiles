<link rel="stylesheet" href="css/phpinfo.css" />
<div id="phpinfo" class="center">
<?php
ob_start();
phpinfo();
$s = ob_get_contents();
ob_end_clean();
preg_match('%(<style type="text/css">.*?</style>).*?<body><div class="center">(.*)</div></body>%s', $s, $matches);

echo $matches[2];
?></div>
