<p>
    <?php foreach($daemons as $daemon): ?>
        <a
        <?php if ($daemon->isManageable()): ?>
            href="/?daemon-control&daemon=<?php echo $daemon->getName() ?>&action=<?php echo $daemon->isStarted() ? 'stop' : 'start' ?>"
        <?php else: ?>
            href="#"
        <?php endif ?>
            class="small button <?php echo $daemon->isStarted() ? 'success' : 'alert' ?>"
        >
            <?php echo $daemon->getName() ?>
        </a>
    <?php endforeach; ?>
</p>
