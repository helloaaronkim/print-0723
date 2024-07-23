#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Deploy this extension to the Exchange Maven repo specified in its Maven build.
#
# Usage  : deploy.sh
# Example: deploy.sh 


scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

UNIT="$(basename $scriptdir)"

# install and deploy the parent POM this project depends on - Exchange validated dependencies for this artifact type
../../deploy-parent-poms.sh

# deploy to Exchange
./deploy-to-exchange.sh

