#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Build this Mule project
# including running all (unit) tests (can be skipped, default is false, i.e., don't skip if not provided), and
# beforehand install (which may include: build) all required local dependencies (those in the same monorepo; can be skipped, default is false, i.e., don't skip if not provided)
#
# Usage  : build.sh <secure-props-key>   [skip-tests] [skip-deps]
# Example: build.sh securePropsCryptoKey false        false

ENCRYPTKEY=$1          # Mule app secure properties en/decryption key - currently unused
SKIP_TESTS=${2:-false} # whether to skip (MUnit) tests, if not set default to false
SKIP_DEPS=${3:-false}  # whether to skip building local dependencies, if not set default to false - currently unused

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

sts="$scriptdir/../../etc/settings.xml"
mvns="mvn -s $sts -ff -U -q"

UNIT="$(basename $scriptdir)"

if [ "$SKIP_DEPS" != "true" ]; then
	# install the parent POM this project depends on
	../../install-parent-poms.sh
fi

echo "Building $UNIT"
# The additional build parameter is required to skip validations since the library is an incomplete Mule app; referencing unknown global configuration and error types that are not known until runtime. As we are aware we are not providing these configurations until runtime, we assume it is safe to disable validations when building the library. This parameter is required since Mule Maven plugin version 3.6.0.
$mvns install # currently not making use of ENCRYPTKEY or SKIP_TESTS but may in future: -Dencrypt.key=$ENCRYPTKEY $skipTests
