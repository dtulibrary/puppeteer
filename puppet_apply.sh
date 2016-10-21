#!/bin/bash
cmd="$(which puppet) apply --modulepath=$MODULE_PATH /default.pp"
echo "Running $cmd"
$cmd
exec bash
