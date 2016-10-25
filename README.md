# Puppeteer

Test your puppet modules in a Docker container on a variety of OS'es.

## Using it

You need Docker to use this tool.

* Put your puppet repos in a common folder and set `PUPPET_HOME` to point to this folder (defaults to `$HOME/puppet`).
* Write a manifest to be applied to the container.
* Run
    
        $ ./run.sh <docker-base-image> <puppet-manifest>

You can use the convenience scripts `wheezy.sh`, `jessie.sh` and `stretch.sh` to skip the first argument
if you're targeting either of the `debian:wheezy`, `debian:jessie` or `debian:stretch` docker base images

## Example

Quick run:

  `./jessie.sh manifests/test.pp`

Given we have defined a puppet module in `$PUPPET_HOME/my_puppet_stuff/modules/rabbitmq/init.pp` for 
installing RabbitMQ. The module takes two parameters on initialization: username and password. To test
this module we then define a manifest describing the `default` node:

    node default {
      class {'rabbitmq':
        username => 'rabbit',
        password => 'rabbit'
      }
    }

and we save this as $HOME/site.pp. Then by running

    $ ./jessie.sh $HOME/site.pp

a `debian:jessie`-based Docker container will be built and run and the rabbitmq puppet module will be applied to this container
from within using puppet apply. When puppet is done you will be dropped to a bash shell in the container
for inspecting the state of the container.

Since Docker base images are much smaller (have less packages pre-installed) than the standard OS distributions,
you will either have to build your own base images that contain the packages, that your server environment has
out-of-the-box from the OS distribution, or you have to build a more elaborate puppet setup and check for
packages that are pre-installed in you server environment but is not part of the Docker base image corresponding
to that environment.

Beware that the manifest you're testing will be copied to the puppeteer directory as `default.pp` and will overwrite
any previous version of that file.
