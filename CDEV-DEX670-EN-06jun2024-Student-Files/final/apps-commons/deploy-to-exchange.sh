#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Deploy this API policy to the Exchange Maven repo specified in its Maven build

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

sts="$scriptdir/../../etc/settings.xml"
mvns="mvn -s $sts -ff -U"

UNIT="$(basename $scriptdir)"

echo "Deploying $UNIT to Exchange Maven repo"
$mvns deploy -DskipTests