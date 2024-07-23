#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

NEW_VERSION="$1"  
# Install old parent poms first so build can find them if snapshot and not published
./install-parent-poms.sh
# Update all final versions, excluding walkthroughs
mvn versions:set -DnewVersion=$NEW_VERSION -DprocessAllModules=true -DgenerateBackupPoms=false
./install-parent-poms.sh
# In each WT project, update parent in each pom-ci.xml to the one installed above
scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

# iterate over all pom-ci.xml files
ciPOMs=$(find . -type f -name 'pom-ci.xml' -maxdepth 6 | sort)
for ciPOM in $ciPOMs; do
	wt=$(dirname $ciPOM)                                                || exit 10
	echo "Updating parent in pom-ci.xml for $wt"                      	|| exit 11
	pushd $wt > /dev/null  												|| exit 12
	mvn versions:update-parent -f pom-ci.xml -DgenerateBackupPoms=false -DallowSnapshots=true -DparentVersion=[$NEW_VERSION] || exit 13
	popd > /dev/null                                       			    || exit 14
done || exit 1