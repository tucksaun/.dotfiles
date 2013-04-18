<?php

namespace TuckSauN;

class Template
{
    static  $TEMPLATE_DIR = '';
    private $file;
    private $vars;
    private $content;
    private $canBeDecorated;

    public function __construct($file)
    {
        $file = sprintf('%s/%s.php', static::$TEMPLATE_DIR, $file);
        if (!file_exists($file) || !is_readable($file)) {
            throw new \InvalidArgumentException(
                $file . ' does not exist os is unreadable.'
            );
        }

        $this->canBeDecorated = true;
        $this->file = $file;
        $this->vars = array();
    }

    public function disableDecoration()
    {
        $this->canBeDecorated = false;
    }

    public function getFile() {
        return $this->file;
    }

    public function getVars() {
        return $this->vars;
    }

    public function __set($name, $value)
    {
        $this->assign($name, $value);
    }

    public function __isset($name)
    {
        return isset($this->vars[$name]);
    }

    public function __get($name)
    {
        if (isset($this->vars[$name])) {

            return $this->vars[$name];
        }

        return null;
    }


    /**
     * Assigns a variable to the template.
     *
     * @param string $name  The variable name
     * @param mixed  $value The variable value
     */
    public function assign($name, $value)
    {
        $this->vars[$name] = $value;

        return $this;
    }

    public function escape($string)
    {
        return htmlspecialchars($string, ENT_QUOTES, 'UTF-8');
    }

    public function compile()
    {
        extract($this->vars);
        ob_start();
        ob_implicit_flush(false);
        require($this->file);

        $this->content = ob_get_clean();

        return $this->content;
    }

    public function decorateWith(Template $decorator)
    {
        if (!$this->content) {
            $this->compile();
        }

        if (!$this->canBeDecorated) {
            return $this->content;
        }

        $decorator->assign('_content', $this->content);

        return $decorator->compile();
    }
}
