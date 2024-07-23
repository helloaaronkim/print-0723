#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Update all files that hold license information

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

sts="$scriptdir/etc/settings.xml"
mvns="mvn -s $sts -fae -U -q"

echo "Installing dependencies required for updating license information"
# must install into Maven repo all apps-commons and resilience-mule-extension to be able to update license information (skipping tests)
./final/apps-commons/build.sh         	   unused true
./final/resilience-mule-extension/build.sh unused true
apscsprojs=$(find walkthroughs -type d -name '*apps-commons*' -maxdepth 4 | sort)
for wt in $apscsprojs; do
	pushd $wt > /dev/null       || exit 10
	./build.sh unused true true || exit 11
	popd > /dev/null            || exit 12
done || exit 1
sysdprojs=$(find walkthroughs -type d -name '*resilience-mule-extension*' -maxdepth 4 | sort)
for wt in $sysdprojs; do
	pushd $wt > /dev/null       || exit 30
	./build.sh unused true true || exit 31
	popd > /dev/null            || exit 32
done || exit 2

echo "Updating license information"
# must execute a phase that the Mule Maven plugin is not bound to: using clean instead of process-resources
$mvns clean -Plicense -DbuildRootDir="$scriptdir"
