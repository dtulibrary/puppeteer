#!/bin/bash

function usage {
  echo "Usage: $0 <docker-base-image> <puppet-manifest>"
  echo "       $0 --help"
  echo
  echo "Builds and runs a container for testing puppet code."
  echo
  echo "Environment variables:"
  echo
  echo "  PUPPET_HOME : Where to find the puppet repositories."
  echo "                For each of these, the path to the"
  echo "                'modules' subdirectory will be added to"
  echo "                the module path for puppet to search."
}

if [[ -z $2 ]]; then
  usage
  if [[ $1 == '--help' ]]; then
    exit 0
  fi
  exit 1
fi

# Check for PUPPET_HOME
if [[ -z $PUPPET_HOME ]]; then
  PUPPET_HOME=$HOME/puppet
  echo "PUPPET_HOME not set. Defaulting to '$PUPPET_HOME'."
fi

if [[ ! -d $PUPPET_HOME ]]; then
  echo "PUPPET_HOME: '$PUPPET_HOME' not found or not a directory"
  exit 1
fi

# Build puppet modulepath
for mp in $(ls -d $PUPPET_HOME/*); do
  if [[ -d $mp/modules ]]; then
    mp="/puppet/${mp##*/}/modules"
    if [[ -z $module_path ]]; then
      module_path=$mp
    else
      module_path=$mp:$module_path
    fi
  fi
done

rm -f default.pp
cp $2 default.pp

# Build container
base_image=$1
tag=$(echo $base_image | tr ':' '_')
cat Dockerfile.template | sed -r "s/\\\$DOCKER_BASE_IMAGE/$base_image/g" > Dockerfile
docker build -t dtic/puppet-test:$tag .

if [[ ! $? -eq 0 ]]; then
  echo "Error building container."
  exit 1
fi

rm Dockerfile

# Run container
exec docker run -ti -e "MODULE_PATH=$module_path" -v "$PUPPET_HOME:/puppet" dtic/puppet-test:$tag $2
