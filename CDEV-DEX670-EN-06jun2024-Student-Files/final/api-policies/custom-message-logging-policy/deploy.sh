#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Deploy this API policy to the Exchange Maven repo specified in its Maven build.
#
# Usage  : deploy.sh
# Example: deploy.sh 

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

UNIT="$(basename $scriptdir)"

# install the parent POM this project depends on
../install-parent-poms.sh

isRelease=$(../../../is-release-version.sh)

if [ "$isRelease" == "true" ]; then
	echo "Deploying release version of $UNIT to Exchange Maven repo"
	./deploy-to-exchange.sh
else
	echo "Refusing to deploy snapshot version of $UNIT to Exchange Maven repo" 1>&2
fi

