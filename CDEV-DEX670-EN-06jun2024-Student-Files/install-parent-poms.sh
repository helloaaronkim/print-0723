#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Install the parent POMs (= the BOM and the parent POM proper) in this directory into the local Maven repository
#
# Usage: install-parent-poms.sh

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

sts="$scriptdir/etc/settings.xml"
mvns="mvn -s $sts -ff -U -q"

$mvns -f bom/pom.xml install:install-file -Dfile=pom.xml -DpomFile=pom.xml
$mvns -f parent-pom/pom.xml install:install-file -Dfile=pom.xml -DpomFile=pom.xml
