#!/bin/bash
default_puppet_home="$HOME/puppet"
puppet_home=$PUPPET_HOME

function usage {
  echo "Usage: $0 <docker-base-image> <puppet-manifest>"
  echo
  echo "Builds and runs a container for testing puppet code."
  echo
  echo "Environment variables:"
  echo
  echo "  PUPPET_HOME : Where to find the 'restricted' and"
  echo "                the 'shared' puppet module directories."
  echo '                Default is "$HOME/puppet"'
}

if [[ -z $2 ]]; then
  usage
  if [[ $1 == '--help' ]]; then
    exit 0
  fi
  exit 1
fi

if [[ -z $puppet_home ]]; then
  puppet_home=$default_puppet_home
  echo "PUPPET_HOME not set. Defaulting to '$puppet_home'."
fi

if [[ ! -d $puppet_home ]]; then
  echo "PUPPET_HOME not found or not a directory: $puppet_home"
  exit 1
fi

for mp in $(ls -d $puppet_home/* | sed -r 's/^.*(\/puppet\/.*)$/\1/'); do
  mp=$mp/modules
  if [[ -z $module_path ]]; then
    module_path=$mp
  else
    module_path=$mp:$module_path
  fi
done

default_base_image=debian:jessie
base_image=$1

if [[ -z $base_image ]]; then
  base_image=$default_base_image
  echo "No base image argument given. Defaulting to '$base_image'."
fi

rm -f default.pp
cp $2 default.pp

# Build container
cat Dockerfile.template | sed -r "s/\\\$DOCKER_BASE_IMAGE/$base_image/g" > Dockerfile
tag=$(echo $base_image | tr ':' '_')
docker build -t dtic/puppet-test:$tag .
rm Dockerfile

# Run container
exec docker run -ti -e "MODULE_PATH=$module_path" -v "$puppet_home:/puppet" dtic/puppet-test:$tag $2
