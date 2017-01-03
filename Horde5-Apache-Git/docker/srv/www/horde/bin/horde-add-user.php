#!/usr/bin/env php
<?php
/**
 * This script will set the permissions on your Horde tree so that the files
 * will be accessible by the web server.
 *
 * Copyright 2016-2017 Horde LLC (http://www.horde.org/)
 *
 * See the enclosed file COPYING for license information (LGPL-2). If you
 * did not receive this file, see http://www.horde.org/licenses/lgpl.
 *
 * @author   Ralf Lang <lang@b1-systems.de>
 * @category Horde
 * @license  http://www.horde.org/licenses/lgpl LGPL-2
 * @package  Horde
 */

$baseFile = __DIR__ . '/../lib/Application.php';
require_once $baseFile;
Horde_Registry::appInit('horde', array(
     'authentication' => 'none',
     'cli' => true
));

$auth = $GLOBALS['injector']->getInstance('Horde_Core_Factory_Auth')->create();
$auth->addUser('lang', array('password' => 'lang'));
                                         
