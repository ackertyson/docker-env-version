#!/bin/bash

if [ -n "$1" ]
then # path to .env provided
  BASEDIR=$( dirname "$1" )
  ENV_FILE=$( basename "$1" )
  if [[ -z $BASEDIR || -z $ENV_FILE || $BASEDIR = $ENV_FILE ]] # couldn't get path/file
  then
    echo "npm: docker-env-version: bad path to .env file provided: $1"
    echo " If you provide a path, it must be a simple filename OR path with filename:"
    echo "  docker-env-version .env-development"
    echo "  docker-env-version ../.env"
    exit 1
  fi
else # no path specified; use ./.env
  BASEDIR=`pwd`
  ENV_FILE='.env'
fi
BASEDIR=${BASEDIR%/} # remove trailing slash

# UPPERCASE package name, replace nonalphanumeric chars with '_'
PACKAGE=`echo $npm_package_name | tr [:lower:] [:upper:] | sed 's/[^a-zA-Z0-9]/_/g'`

if [ -e $BASEDIR/$ENV_FILE ] # check whether .env file exists
then
  if [ ! -f $BASEDIR/$ENV_FILE ] # exists but isn't regular file
  then
    echo "npm: docker-env-version: provided .env file exists and is not a regular file"
    echo " OR bad path to .env file: $1"
    echo " If you provide a path, it must be a simple filename OR path with filename:"
    echo "  docker-env-version .env-development"
    echo "  docker-env-version ../.env"
    exit 1
  else # file exists; remove existing version var
    sed /^${PACKAGE}_VERSION=/d $BASEDIR/$ENV_FILE > $BASEDIR/.tmp.docker-env-version
    mv $BASEDIR/.tmp.docker-env-version $BASEDIR/$ENV_FILE # kill sed-generated file
  fi
else # doesn't exist; create it
  touch $BASEDIR/$ENV_FILE
fi

echo "${PACKAGE}_VERSION=$npm_package_version" >> $BASEDIR/$ENV_FILE # add new version var

exit 0
