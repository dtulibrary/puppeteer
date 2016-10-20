# Puppeteer

Test your puppet modules in a Docker container on a variety of OS'es (currently Debian Wheezy and Debian Jessie).

## Using it

You need Docker to use this tool.

* Put your puppet repos in a common folder and set PUPPET\_HOME to point to this folder (defaults to $HOME/puppet).
* Run
    
    $ ./run.sh <jessie|wheezy> <puppet-module>

You can use the convenience scripts jessie.sh and wheezy.sh to skip the first argument.
