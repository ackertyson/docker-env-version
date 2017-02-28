#!/bin/bash

if [ -n "$1" ]
then # path to .env provided
  BASEDIR=$1
else # no path specified; use PWD
  BASEDIR=`pwd`
fi
BASEDIR=${BASEDIR%/} # remove trailing slash

# UPPERCASE package name, replace nonalphanumeric chars with '_'
PACKAGE=`echo $npm_package_name | tr [:lower:] [:upper:] | sed 's/[^a-zA-Z0-9]/_/g'`

if [ -e $BASEDIR/.env ] # make sure .env file exists
then
  if [ ! -f $BASEDIR/.env ]
  then
    echo "npm: docker-env-version: $BASEDIR/.env exists but is not a regular file?"
    exit 1
  fi
else
  touch $BASEDIR/.env
fi

sed /^${PACKAGE}_VERSION=/d $BASEDIR/.env > $BASEDIR/.tmp.docker-env-version # remove existing version var
mv $BASEDIR/.tmp.docker-env-version $BASEDIR/.env # kill sed-generated file

echo "${PACKAGE}_VERSION=$npm_package_version" >> $BASEDIR/.env # add new version var

exit 0
