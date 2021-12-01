<?php

//Load config
require_once 'app/config/config.php';

//Start app
include 'app/bootstrap.php';

$core = new Core();

include 'home/home.html.php';
