#!/bin/bash
$(which puppet) apply --modulepath=$MODULE_PATH /default.pp
