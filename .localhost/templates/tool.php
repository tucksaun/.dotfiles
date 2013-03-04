<?php if ($tool['iframe']): ?>
<iframe id="frame" src="<?php echo $tool['url'] ?>" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%" scrolling="auto"></iframe>
<script type="text/javascript">
function resizeIframe() {
    var height = document.documentElement.clientHeight;
    height -= document.getElementById('frame').offsetTop;

    // not sure how to get this dynamically
    height -= 0; /* whatever you set your body bottom margin/padding to be */

    document.getElementById('frame').style.height = height +"px";

};
document.getElementById('frame').onload = resizeIframe;
window.onresize = resizeIframe;
</script>
<?php
    else:
        $_SERVER['PHP_SELF'] = "?tool=".$tool['name'];
        require WEB_DIR.$tool['url'];
    endif;
?>
