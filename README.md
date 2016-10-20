# Puppeteer

Test your puppet modules in a Docker container on a variety of OS'es (currently Debian Wheezy and Debian Jessie).

## Using it

You need Docker to use this tool.

* Put your puppet repos in a common folder and set `PUPPET_HOME` to point to this folder (defaults to `$HOME/puppet`).
* Write a manifest to be applied to the container.
* Run
    
        $ ./run.sh <jessie|wheezy> <puppet-manifest>

You can use the convenience scripts `jessie.sh` and `wheezy.sh` to skip the first argument.

## Example Manifest

$HOME/site.pp:

        node default {
          class {'metastore::controller5':
            conf_set => 'production'
          }
        }

## Running the example

        $ ./jessie.sh $HOME/site.pp

Beware that the manifest will be copied to the puppeteer directory as `default.pp` and will overwrite
any previous version of that file.
