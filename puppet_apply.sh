#!/bin/bash
puppet_module=$1

if [[ -z $puppet_module ]]; then
  echo "Please specify a puppet module to apply."
  exit 1
fi

echo "include $1" > /site.pp

cmd="puppet apply --modulepath=$MODULE_PATH /site.pp"
echo "Executing '$cmd'"
exec $cmd
