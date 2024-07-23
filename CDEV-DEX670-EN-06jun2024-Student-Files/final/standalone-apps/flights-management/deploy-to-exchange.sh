#!/bin/bash
# Copyright (C) MuleSoft, Inc. All rights reserved. http://www.mulesoft.com
#
# The software in this package is published under the terms of the
# Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License,
# a copy of which has been included with this distribution in the LICENSE.txt file.
set -Eeuo pipefail

# Deploy this Mule app to Exchange
#
# Usage  : deploy-to-exchange.sh <secure-props-key>
# Example: deploy-to-exchange.sh securePropsCryptoKey

ENCRYPTKEY=$1 # Mule app secure properties en/decryption key

scriptdir="$(cd "$(dirname "$0")" && pwd)"
cd $scriptdir

sts="$scriptdir/../../../etc/settings.xml"
mvns="mvn -s $sts -ff -U -q -DskipTests=true"

UNIT="$(basename $scriptdir)"
isRelease=$(../../../is-release-version.sh)

if [ "$isRelease" == "true" ]; then
  echo "Deploying release version of $UNIT"
  $mvns deploy -Dencrypt.key=$ENCRYPTKEY
else
	echo "Refusing to deploy snapshot version of $UNIT" 1>&2
fi
