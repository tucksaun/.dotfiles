<!DOCTYPE html>
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->

  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width" />
    <link rel="stylesheet" href="css/normalize.css" />
    <link rel="stylesheet" href="css/foundation.min.css" />
    <?php /*<script src="js/vendor/custom.modernizr.js"></script> */ ?>
    <title>TuckSauN - Projects</title>
  </head>
  <body>
    <nav class="top-bar">
      <ul class="title-area">
        <li class="name">
          <h1><a href="/">TuckSauN</a></h1>
        </li>
      </ul>

      <section class="top-bar-section">
        <!-- Left Nav Section -->
        <ul class="left">
          <li class="divider"></li>
          <li><a href="/">Projects list</a></li>
        <?php foreach ($utils as $key => $info) : ?>
          <li class="divider"></li>
          <li><a href="/?tool=<?php echo $key ?>"><?php echo $info['label'] ?></a></li>
        <?php endforeach; ?>
        </ul>
      </section>
    </nav>

    <?php echo $_content ?>

    <?php /*<script>
      document.write(
        '<script src=' +
        ('__proto__' in {} ? 'js/vendor/zepto' : 'js/vendor/jquery') +
        '.js><\/script>'
      );
    </script>
    <script src="js/foundation/foundation.alerts.js"></script>
    <script src="js/foundation/foundation.clearing.js"></script>
    <script src="js/foundation/foundation.cookie.js"></script>
    <script src="js/foundation/foundation.dropdown.js"></script>
    <script src="js/foundation/foundation.forms.js"></script>
    <script src="js/foundation/foundation.joyride.js"></script>
    <script src="js/foundation/foundation.js"></script>
    <script src="js/foundation/foundation.magellan.js"></script>
    <script src="js/foundation/foundation.orbit.js"></script>
    <script src="js/foundation/foundation.placeholder.js"></script>
    <script src="js/foundation/foundation.reveal.js"></script>
    <script src="js/foundation/foundation.section.js"></script>
    <script src="js/foundation/foundation.tooltips.js"></script>
    <script src="js/foundation/foundation.topbar.js"></script> */?>
  </body>
</html>
