#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Clean (remove) all artifacts here and below here
# beforehand install (which may include: build) all required local dependencies (those in the same monorepo)
#
# Usage: clean.sh

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

sts="$scriptdir/../etc/settings.xml"
mvns="mvn -s $sts -fn -U -q"

UNIT="$(basename $scriptdir)"

# install the parent POMs these projects depend on
../install-parent-poms.sh

echo "Cleaning $UNIT"
$mvns clean:clean -Dmaven.clean.failOnError=false
# remove remnants of complex build that requires renaming pom-ci.xml to pom.xml and 
# therefore intermittently copying pom.xml to pom.xml.tmp-during-build
find . -type f -name pom.xml.tmp-during-build -exec rm {} \;
