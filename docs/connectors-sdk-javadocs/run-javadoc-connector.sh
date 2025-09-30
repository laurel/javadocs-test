#!/bin/sh
# run-javadoc-connectors.sh
#
# Generates javadocs for the Connector SDK API.
#
# args:
#  1. full path to Connectors SD:
#  2. full path to Javadoc output directory
#  3. SDK version (from tag name - see https://github.com/lucidworks/connectors-sdk/releases)
#
DIR=`pwd`
SDK='connector-plugin-sdk'

if [ $# -le 2 ]
then
    echo "Usage:\t $0 <full path to Connectors SDK repo dir> <path to javadoc ouput dir> <version number>"
    exit 1
fi

SDK_SRC="${1}"
if [ ! -d "${SDK_SRC}" ]
then
	echo "Expecting existing Connectors SDK src dir: ${SDK_SRC}"
    exit
fi
echo "Connectors SDK source dir: ${SDK_SRC}"

JAVADOCS=$2
if [ ! -d "${JAVADOCS}" ]
then
    echo "Expecting existing javadocs output dir: ${JAVADOCS}"
    exit
fi
echo "Javadocs dir: ${JAVADOCS}"

TAG=$3
VERSION=${TAG#?}
echo "Connectors SDK version: ${TAG}/${VERSION}"

cd ${SDK_SRC}
git checkout master # ${TAG} fix in APOLLO-19770
git pull
./gradlew -p ${SDK} javadoc -Prelease.version=${VERSION}

cd $DIR
cp -fr ${SDK_SRC}/${SDK}/build/docs/javadoc/* ${JAVADOCS}
