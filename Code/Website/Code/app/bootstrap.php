<?php

//Loading libraries
spl_autoload_register(function($className) {
	require_once APP_ROOT.'/app/library/'.$className.'/'.$className.'.php';
});
