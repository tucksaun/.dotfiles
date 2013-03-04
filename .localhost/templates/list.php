<div class="row">
  <div class="large-12 columns">
    <h2>TuckSauN - Projects</h2>
    <hr />
  </div>
</div>
<div class="row">
  <div class="large-12 columns">
    <div class="row">
      <div class="large-7 columns">
        <div class="panel">

          <p>
            <ul>
            <?php foreach ($projects as $project): ?>
              <li>
              <?php if ($project->hasSubProjects()): ?>
                <h6><?php echo $project->getName() ?></h6>
                <ul>
                <?php foreach ($project->getSubProjects() as $subProject): ?>
                  <li>
                    <img height="16" width="16" style="display: inline-block;" src="<?php echo $project->getFavicon() ?>" />
                    <a href="<?php echo $subProject->getLink() ?>"><?php echo $subProject->getName() ?></a>
                  </li>
                <?php endforeach; ?>
                </ul>
              <?php else: ?>
                <img height="16" width="16" style="display: inline-block;" src="<?php echo $project->getFavicon() ?>" />
                <a href="<?php echo $project->getLink() ?>"><?php echo $project->getName() ?></a>
              <?php endif; ?>
              </li>
            <?php endforeach; ?>
            </ul>
          </p>

        </div>
      </div>
      <div class="large-5 columns">
        <div class="panel">
          <p>Some RSS feeds or computer stats here?</p>
        </div>
        <div class="panel">
          <p>
            <a href="#" class="small button success">Nginx</a>
            <a href="#" class="small button">PHP FPM</a>
            <a href="#" class="small button alert">MySQL</a>
            <a href="#" class="small button alert">PostgreSQL</a>
            <a href="#" class="small button alert">Sonar</a>
            <a href="#" class="small button alert">Hudson</a>
          </p>
        </div>
      </div>
    </div>
  </div>
</div>
