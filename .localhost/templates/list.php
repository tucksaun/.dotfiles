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
        <div class="panel daemons"></div>
      </div>
    </div>
  </div>
</div>
<script type="text/javascript">
  if (window.XMLHttpRequest) {
    // code for IE7+, Firefox, Chrome, Opera, Safari
    xmlhttp=new XMLHttpRequest();
  } else {
    // code for IE6, IE5
    xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
  xmlhttp.onreadystatechange=function() {
    if (xmlhttp.readyState==4 && xmlhttp.status==200) {
      document.getElementsByClassName("daemons")[0].innerHTML=xmlhttp.responseText
    }
  }
  xmlhttp.open("GET","/?tool=daemons",true);
  xmlhttp.send();
</script>
