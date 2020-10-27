#!/bin/bash

author="Istvan Horvath"

echo "Please input plugin name: ";
read pluginname;

echo "Please input a short description: ";
read description;
description="Plugin for managing Pro-Vitam partners."


namespace=`echo $pluginname | awk '{
  for (i=1; i<=NF; i++) {
    printf(substr($i, 1, 1));
  }
  printf("\n");
}'`
namespace=${namespace,,}

echo "Is namespace '$namespace' good? [Y/n] ";
read yn;
if [ -z $yn ] || [ $yn == 'Y' ]; then
   echo "Keeping $namespace";
else
  echo "Introduce new namespace: ";
  read namespace;
fi

mainName=`echo ${pluginname,,} | sed 's/ /-/g'`
prefix=${namespace^^};

mkdir $mainName;

echo "<?php
/*
*   @package $pluginname
*/

/*
 * Plugin Name:     $pluginname
 * Description:     $description
 * Author:          $author
 * License:         GPLv2 or later
*/
namespace $namespace;

if ( ! defined('ABSPATH') ) { die; }

define( '$prefix\_PLUGIN_DIR', plugin_dir_path( __FILE__ ) );
define( '$prefix\_PLUGIN_URL', plugin_dir_url( __FILE__ ) );

require_once( 'activation.php' );
register_activation_hook( __FILE__, '\\$nampespace\activation' );

" > $mainName/$mainName.php


echo "<?php
namespace $namespace;

function activation(){
  return 0;
}
" > $mainName/activation.php

mkdir $mainName/database

echo "<?php
namespace $namespace\database;

const TABLE_PREFIX = '$namespace_';
" > $mainName/database/defines.php

echo "<?php
namespace $namespace\database;
" > $mainName/database/functions.php
