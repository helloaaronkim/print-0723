#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Build all artifacts here and below here
# including running all (unit) tests (can be skipped, default is false, i.e., don't skip if not provided), and
# beforehand install (which may include: build) all required local dependencies (those in the same monorepo)
#
# Usage  : build.sh <secure-props-key>   [skip-tests]
# Example: build.sh securePropsCryptoKey false       

ENCRYPTKEY=$1          # Mule app secure properties en/decryption key
SKIP_TESTS=${2:-false} # whether to skip (MUnit) tests, if not set default to false

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

pomci=pom-ci.xml

sts="$scriptdir/../etc/settings.xml"
mvns="mvn -s $sts -ff -U -q"

UNIT="$(basename $scriptdir)"

# install the parent POMs these projects depend on
../install-parent-poms.sh

# the GitHub Actions workers keep running out of disk space: try to minimize disk space in all of the following by doing 'mvn clean' ASAP

echo "Building $UNIT"
# can't just do the following because due to a limitation in the Mule Maven plugin, the POM must always be called pom.xml
#$mvns -f $pomci install ...
# instead, must work around this limitation:
builds=$(find dev* -type f -name 'build.sh' -maxdepth 5 | sort)
for build in $builds; do
	wt=$(dirname $build)                              || exit 10
	echo "Building $wt:"                              || exit 11
	pushd $wt > /dev/null                             || exit 12
	./build.sh "$ENCRYPTKEY" true "$SKIP_TESTS"       || exit 13
	$mvns clean:clean -Dmaven.clean.failOnError=false || exit 14
	popd > /dev/null                                  || exit 15
done || exit 1

if [ "$SKIP_TESTS" != "true" ]; then
	# now build each WT project from the point of view of a student, using the BOM and parent POM assigned to each respective WT project
	# this is only done when tests are not skipped, as the whole point of this is to run tests in a student-like setting
	echo "Building like a student $UNIT"
	builds=$(find dev* -type f -name 'build.sh' -maxdepth 5 | sort)
	for build in $builds; do
		wt=$(dirname $build)                              || exit 20
		echo "Building like a student $wt:"               || exit 21
		pushd $wt > /dev/null                             || exit 22
		./build.sh "$ENCRYPTKEY" false                    || exit 23
		$mvns clean:clean -Dmaven.clean.failOnError=false || exit 24
		popd > /dev/null                                  || exit 25
	done || exit 2
	# installing the main (non-student) build's parent POMs after the student build has installed local versions of some of these POMs
	../install-parent-poms.sh
fi
