#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Clean (remove) all artifacts here and below here
#
# Usage: clean.sh

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

UNIT="$(basename $scriptdir)"

echo "Cleaning $UNIT"
./final/clean.sh
./walkthroughs/clean.sh
