#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Deploy all ppoms to the Exchange Maven repo specified in its Maven build.
#
# Usage  : deploy.sh 
# Example: deploy.sh

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

# install the parent POM this project depends on
./install-parent-poms.sh

sts="$scriptdir/etc/settings.xml"
mvns="mvn -s $sts -fn -U"


poms=('bom/pom.xml' 'parent-pom/pom.xml')
for p in "${poms[@]}"
do
	echo $p
	# Extension version can be anything, incl. a snapshot version
	$mvns deploy -f $p -Pdeploy-to-exchange-v3
done