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
# Usage  : build.sh <secure-props-key-for-final-solution> <secure-props-key-for-walkthroughs> [skip-tests]
# Example: build.sh securePropsCryptoKeyForFinalSolution  securePropsCryptoKeyForWalkthroughs false       

FIN_ENCRYPTKEY=$1      # Mule app secure properties en/decryption key for final solution
WTS_ENCRYPTKEY=$2      # Mule app secure properties en/decryption key for walkthrough solutions
SKIP_TESTS=${3:-false} # whether to skip (MUnit) tests, if not set default to false

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

UNIT="$(basename $scriptdir)"

echo "Building $UNIT"
./final/build.sh        "$FIN_ENCRYPTKEY" "$SKIP_TESTS"
./walkthroughs/build.sh "$WTS_ENCRYPTKEY" "$SKIP_TESTS"
